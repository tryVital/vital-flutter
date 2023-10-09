package io.vital

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.activity.result.contract.ActivityResultContract
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.tryvital.client.Environment
import io.tryvital.client.Region
import io.tryvital.client.VitalClient
import io.tryvital.client.utils.VitalLogger
import io.tryvital.vitalhealthconnect.VitalHealthConnectManager
import io.tryvital.vitalhealthconnect.model.HealthConnectAvailability
import io.tryvital.vitalhealthconnect.model.PermissionOutcome
import io.tryvital.vitalhealthconnect.model.SyncStatus
import io.tryvital.vitalhealthconnect.model.VitalResource
import io.tryvital.vitalhealthconnect.model.WritableVitalResource
import io.tryvital.vitalhealthconnect.model.processedresource.ProcessedResourceData
import io.tryvital.vitalhealthconnect.model.processedresource.QuantitySample
import io.tryvital.vitalhealthconnect.model.processedresource.SummaryData
import io.tryvital.vitalhealthconnect.model.processedresource.TimeSeriesData
import kotlinx.coroutines.*
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant

/** VitalHealthPlugin */
class VitalHealthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private val logger = VitalLogger.getOrCreate()

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    private val vitalClient: VitalClient
        get() = VitalClient.getOrCreate(context)

    private val vitalHealthConnectManager: VitalHealthConnectManager
        get() = VitalHealthConnectManager.getOrCreate(context)

    private var activity: Activity? = null

    private var activeAskRequest: Pair<ActivityResultContract<Unit, Deferred<PermissionOutcome>>, Result>? = null

    private var taskScope = CoroutineScope(SupervisorJob())

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        taskScope.cancel()
        taskScope = CoroutineScope(SupervisorJob())

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_health_connect")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)

        startStatusUpdate()
    }

    private fun startStatusUpdate() {
        taskScope.launch {
            try {
                vitalHealthConnectManager?.status?.collect {
                    withContext(Dispatchers.Main) {
                        when (it) {
                            is SyncStatus.ResourceSyncFailed -> channel.invokeMethod(
                                "status",
                                listOf("failedSyncing", it.resource.name)
                            )
                            is SyncStatus.ResourceNothingToSync -> channel.invokeMethod(
                                "status",
                                listOf("nothingToSync", it.resource.name)
                            )
                            is SyncStatus.ResourceSyncing -> channel.invokeMethod(
                                "status",
                                listOf("syncing", it.resource.name)
                            )
                            is SyncStatus.ResourceSyncingComplete -> channel.invokeMethod(
                                "status",
                                listOf("successSyncing", it.resource.name)
                            )
                            SyncStatus.SyncingCompleted -> channel.invokeMethod(
                                "status",
                                listOf("syncingCompleted")
                            )
                            SyncStatus.Unknown -> channel.invokeMethod(
                                "status",
                                listOf("unknown")
                            )
                        }
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    channel.invokeMethod(
                        "unknown", listOf("failedSyncing")
                    )
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        taskScope.cancel()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        logger.logI("onMethodCall: ${call.method}")

        when (call.method) {
            "configureClient" -> {
                configureClient(call, result)
            }
            "configureHealthConnect" -> {
                configureHealthConnect(call, result)
            }
            "setUserId" -> {
                setUserId(call, result)
            }
            "syncData" -> {
                syncData(call, result)
            }
            "askForResources" -> {
                askForResources(call, result)
            }
            "cleanUp" -> {
                cleanUp(result)
            }
            "writeHealthData" -> {
                writeHealthData(call, result)
            }
            "read" -> {
                read(call, result)
            }
            else -> throw Exception("Unsupported method ${call.method}")
        }
    }

    private fun askForResources(call: MethodCall, result: Result) {
        if (synchronized(this) { activeAskRequest != null }) {
            return result.error("VitalHealthError", "another ask request is in progress", null)
        }

        val activity = this.activity ?: return result.error("VitalHealthError", "No active Android Activity", null)

        val readResources = call.argument<List<String>>("readResources") ?: emptyList()
        val writeResources = call.argument<List<String>>("writeResources") ?: emptyList()

        val contract = vitalHealthConnectManager.createPermissionRequestContract(
            readResources = readResources.mapNotNullTo(mutableSetOf()) { runCatching { VitalResource.valueOf(it) }.getOrNull() },
            writeResources = writeResources.mapNotNullTo(mutableSetOf()) { runCatching { WritableVitalResource.valueOf(it) }.getOrNull() },
        )

        synchronized(this) {
            activeAskRequest = Pair(contract, result)
        }

        activity.startActivityForResult(
            contract.createIntent(context, Unit), 1984
        )
    }

    override fun onActivityResult(p0: Int, p1: Int, p2: Intent?): Boolean {
        if (p0 == 1984) {
            val activeAskRequest = synchronized(this) { this.activeAskRequest ?: return false }

            taskScope.launch {
                val (contract, result) = activeAskRequest
                contract.parseResult(p1, p2).await()

                result.success(true)

                synchronized(this) {
                    this@VitalHealthPlugin.activeAskRequest = null
                }
            }
            return true
        }
        return false
    }

    private fun writeHealthData(call: MethodCall, result: Result) {
        result.execute(taskScope) {
            vitalHealthConnectManager.writeRecord(
                WritableVitalResource.valueOf(
                    call.argument<String>("resource")!!
                ),
                startDate = Instant.ofEpochMilli(call.argument("startDate")!!),
                endDate = Instant.ofEpochMilli(call.argument("endDate")!!),
                value = call.argument("value")!!,
            )
            return@execute null
        }
    }

    private fun read(call: MethodCall, result: Result) {
        result.execute(taskScope) {
            val readResult = vitalHealthConnectManager.read(
                VitalResource.valueOf(
                    call.argument<String>("resource")!!
                ),
                startTime = Instant.ofEpochMilli(call.argument("startDate")!!),
                endTime = Instant.ofEpochMilli(call.argument("endDate")!!),
            )

            return@execute when (readResult) {
                is ProcessedResourceData.Summary -> {
                    when (readResult.summaryData) {
                        is SummaryData.Profile -> {
                            JSONObject(
                                mapOf(
                                    "biologicalSex" to (readResult.summaryData as SummaryData.Profile).biologicalSex,
                                    "dateOfBirth" to (readResult.summaryData as SummaryData.Profile).dateOfBirth.time,
                                    "heightInCm" to (readResult.summaryData as SummaryData.Profile).heightInCm,
                                )
                            ).toString()
                        }

                        is SummaryData.Body -> {
                            JSONObject(
                                mapOf(
                                    "bodyMass" to JSONArray((readResult.summaryData as SummaryData.Body).bodyMass.map {
                                        mapSampleToJson(it)
                                    }),
                                    "bodyFatPercentage" to JSONArray((readResult.summaryData as SummaryData.Body).bodyFatPercentage.map {
                                        mapSampleToJson(it)
                                    }),
                                )
                            ).toString()
                        }

                        is SummaryData.Activities -> {
                            JSONObject(
                                mapOf(
                                    "activities" to JSONArray((readResult.summaryData as SummaryData.Activities).activities.map {
                                        JSONObject().apply {
                                            put(
                                                "activeEnergyBurned",
                                                JSONArray(it.activeEnergyBurned.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "basalEnergyBurned",
                                                JSONArray(it.basalEnergyBurned.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "steps",
                                                JSONArray(it.steps.map { mapSampleToJson(it) })
                                            )
                                            put(
                                                "distanceWalkingRunning",
                                                JSONArray(it.distanceWalkingRunning.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "vo2Max",
                                                JSONArray(it.vo2Max.map { mapSampleToJson(it) })
                                            )
                                            put(
                                                "floorsClimbed",
                                                JSONArray(it.floorsClimbed.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                        }
                                    }),
                                )
                            ).toString()
                        }

                        is SummaryData.Workouts -> {
                            JSONObject(
                                mapOf(
                                    "workouts" to JSONArray((readResult.summaryData as SummaryData.Workouts).samples.map {
                                        JSONObject().apply {
                                            put("id", it.id)
                                            put("startDate", it.startDate.time)
                                            put("endDate", it.endDate.time)
                                            put("sourceBundle", it.sourceBundle)
                                            put("deviceModel", it.deviceModel)
                                            put("sport", it.sport)
                                            put(
                                                "caloriesInKiloJules",
                                                it.caloriesInKiloJules
                                            )
                                            put("distanceInMeter", it.distanceInMeter)
                                            put(
                                                "heartRate",
                                                JSONArray(it.heartRate.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "respiratoryRate",
                                                JSONArray(it.respiratoryRate.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                        }
                                    }),
                                )
                            ).toString()
                        }

                        is SummaryData.Sleeps -> {
                            JSONObject(
                                mapOf(
                                    "sleeps" to JSONArray((readResult.summaryData as SummaryData.Sleeps).samples.map {
                                        JSONObject().apply {
                                            put("id", it.id)
                                            put("startDate", it.startDate.time)
                                            put("endDate", it.endDate.time)
                                            put("sourceBundle", it.sourceBundle)
                                            put("deviceModel", it.deviceModel)
                                            put(
                                                "heartRate",
                                                JSONArray(it.heartRate.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "restingHeartRate",
                                                JSONArray(it.restingHeartRate.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "heartRateVariability",
                                                JSONArray(it.heartRateVariability.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "oxygenSaturation",
                                                JSONArray(it.oxygenSaturation.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put(
                                                "respiratoryRate",
                                                JSONArray(it.respiratoryRate.map {
                                                    mapSampleToJson(it)
                                                })
                                            )
                                            put("sleepStages", JSONObject().apply {
                                                put(
                                                    "awakeSleepSamples",
                                                    it.stages.awakeSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "deepSleepSamples",
                                                    it.stages.deepSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "lightSleepSamples",
                                                    it.stages.lightSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "remSleepSamples",
                                                    it.stages.remSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "outOfBedSleepSamples",
                                                    it.stages.outOfBedSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "unknownSleepSamples",
                                                    it.stages.unknownSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                            })
                                        }
                                    }),
                                )
                            ).toString()
                        }
                    }
                }

                is ProcessedResourceData.TimeSeries -> {
                    when (val data = readResult.timeSeriesData) {
                        is TimeSeriesData.QuantitySamples ->
                            JSONObject(
                                mapOf(
                                    "timeSeries" to JSONArray(data.samples.map {
                                        mapSampleToJson(it)
                                    }),
                                )
                            ).toString()

                        is TimeSeriesData.BloodPressure -> {
                            JSONObject(
                                mapOf(
                                    "timeSeries" to JSONArray(data.samples.map {
                                        JSONObject().apply {
                                            put("systolic", mapSampleToJson(it.systolic))
                                            put("diastolic", mapSampleToJson(it.diastolic))
                                            put(
                                                "pulse",
                                                it.pulse?.let { it1 -> mapSampleToJson(it1) })
                                        }
                                    })
                                )
                            ).toString()
                        }
                    }
                }
            }
        }

    }

    private fun syncData(call: MethodCall, result: Result) {
        result.execute(taskScope) {
            val resources = call.argument<List<String>>("resources") ?: emptyList()

            vitalHealthConnectManager.syncData(
                resources.mapNotNull { runCatching { VitalResource.valueOf(it) }.getOrNull() }.toSet().ifEmpty { null }
            )
            return@execute null
        }
    }

    private fun setUserId(call: MethodCall, result: Result) {
        result.execute(taskScope) {
            VitalClient.setUserId(context, call.argument<String?>("userId")!!)
            return@execute null
        }
    }

    private fun configureHealthConnect(call: MethodCall, result: Result) {
        val manager = VitalHealthConnectManager.getOrCreate(context)
        val availability = VitalHealthConnectManager.isAvailable(context)

        if (availability != HealthConnectAvailability.Installed) {
            return result.error(
                "ClientSetup",
                "Health Connect is unavailable: ${availability}",
                null
            )
        }

        result.execute(taskScope) {
            manager.configureHealthConnectClient(
                logsEnabled = call.argument<Boolean?>("logsEnabled")!!,
                syncOnAppStart = call.argument<Boolean?>("syncOnAppStart")!!,
                numberOfDaysToBackFill = call.argument<Int?>("numberOfDaysToBackFill")!!,
            )
            return@execute null
        }
    }

    private fun configureClient(call: MethodCall, result: Result) {
        result.execute(taskScope) {
            VitalClient.configure(
                context,
                Region.valueOf(call.argument<String>("region")!!.uppercase()),
                Environment.valueOf(call.argument<String>("environment")!!.replaceFirstChar { it.uppercase() }),
                call.argument<String>("apiKey")!!
            )
            return@execute null
        }
    }

    private fun cleanUp(result: Result) {
        vitalHealthConnectManager.cleanUp()
        result.success(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
}

private fun mapSampleToJson(it: QuantitySample): JSONObject {
    return JSONObject().apply {
        put("id", it.id)
        put("value", it.value)
        put("unit", it.unit)
        put("startDate", it.startDate.time)
        put("endDate", it.endDate.time)
        put("sourceBundle", it.sourceBundle)
        put("deviceModel", it.deviceModel)
        put("type", it.type)
        put("metadata", it.metadata)
    }
}

private inline fun Result.execute(scope: CoroutineScope, crossinline action: suspend () -> Any?) = scope.launch {
    try {
        val result = action()
        success(result)
    } catch (e: Throwable) {
        error("VitalHealthError", "${e::class.simpleName} ${e.message}", null)
    }
}

