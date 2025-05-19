@file:OptIn(ExperimentalVitalApi::class)

package io.vital.health

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultCallback
import androidx.activity.result.ActivityResultLauncher
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
import io.tryvital.client.services.data.LocalQuantitySample
import io.tryvital.client.utils.VitalLogger
import io.tryvital.vitalhealthconnect.DefaultSyncNotificationBuilder
import io.tryvital.vitalhealthconnect.DefaultSyncNotificationContent
import io.tryvital.vitalhealthconnect.ExperimentalVitalApi
import io.tryvital.vitalhealthconnect.VitalHealthConnectManager
import io.tryvital.vitalhealthconnect.disableBackgroundSync
import io.tryvital.vitalhealthconnect.enableBackgroundSyncContract
import io.tryvital.vitalhealthconnect.isBackgroundSyncEnabled
import io.tryvital.vitalhealthconnect.model.HealthConnectAvailability
import io.tryvital.vitalhealthconnect.model.PermissionOutcome
import io.tryvital.vitalhealthconnect.model.PermissionStatus
import io.tryvital.vitalhealthconnect.model.SyncStatus
import io.tryvital.vitalhealthconnect.model.VitalResource
import io.tryvital.vitalhealthconnect.model.WritableVitalResource
import io.tryvital.vitalhealthconnect.model.processedresource.ProcessedResourceData
import io.tryvital.vitalhealthconnect.model.processedresource.SummaryData
import io.tryvital.vitalhealthconnect.model.processedresource.TimeSeriesData
import kotlinx.coroutines.*
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant
import java.util.concurrent.atomic.AtomicReference

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
    private var activeEnableBgSync: Pair<ActivityResultContract<Unit, Boolean>, Result>? = null

    private var taskScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        taskScope.cancel()
        taskScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_health_connect")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)

        startStatusUpdate()
    }

    private fun startStatusUpdate() {
        taskScope.launch {
            try {
                vitalHealthConnectManager.status.collect {
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
            } catch (e: Throwable) {
                withContext(Dispatchers.Main) {
                    channel.invokeMethod(
                        "status", listOf("failedSyncing")
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
            "configureHealthConnect" -> configureHealthConnect(call, result)
            "syncData" -> syncData(call, result)
            "askForResources" -> askForResources(call, result)
            "writeHealthData" -> writeHealthData(call, result)
            "read" -> read(call, result)

            "hasAskedForPermission" -> result.execute(taskScope) {
                val input = call.arguments<String>()!!
                val resource = try {
                    VitalResource.valueOf(input)
                } catch (e: NoSuchElementException) {
                    throw RuntimeException("unsupported resource: $input")
                }
                vitalHealthConnectManager.hasAskedForPermission(resource)
            }

            "permissionStatus" -> result.execute(taskScope) {
                val resources = call.arguments<List<String>>() ?: emptyList()
                val parsedResources = try {
                    resources.map { VitalResource.valueOf(it) }
                } catch (e: NoSuchElementException) {
                    throw RuntimeException("input contains unsupported resources: $resources")
                }
                JSONObject(
                    vitalHealthConnectManager.permissionStatus(parsedResources)
                        .mapKeys { it.key.name }
                        .mapValues { if (it.value == PermissionStatus.Asked) "asked" else "notAsked" }
                ).toString()
            }

            "isAvailable" -> {
                result.success(
                    VitalHealthConnectManager.isAvailable(context) == HealthConnectAvailability.Installed
                )
            }
            "getPauseSynchronization" -> {
                result.success(vitalHealthConnectManager.pauseSynchronization)
            }
            "setPauseSynchronization" -> {
                vitalHealthConnectManager.pauseSynchronization = call.arguments<Boolean>()!!
                result.success(null)
            }
            "isBackgroundSyncEnabled" -> {
                result.success(vitalHealthConnectManager.isBackgroundSyncEnabled)
            }

            "enableBackgroundSync" -> enableBackgroundSync(call, result)

            "disableBackgroundSync" -> result.execute(taskScope) {
                vitalHealthConnectManager.disableBackgroundSync()
                return@execute null
            }

            "setSyncNotificationContent" -> setSyncNotificationContent(call, result)
            else -> throw Exception("Unsupported method ${call.method}")
        }
    }

    private fun askForResources(call: MethodCall, result: Result) {
        val availability = VitalHealthConnectManager.isAvailable(context)
        if (availability != HealthConnectAvailability.Installed) {
            return result.error("VitalHealthError", "Health Connect is not available: $availability", null)
        }

        if (synchronized(this) { activeAskRequest != null }) {
            return result.error("VitalHealthError", "another ask request is in progress", null)
        }

        val activity = this.activity ?: return result.error("VitalHealthError", "No active Android Activity", null)
        if (activity !is ComponentActivity) {
            return result.error("VitalHealthError", "The MainActivity of your Flutter host app must be a `FlutterFragmentActivity` subclass for the permission request flow to function properly.", null)
        }

        val inputs = call.arguments<List<Any>>() ?: emptyList()
        if (inputs.size != 2) {
            return result.error("VitalHealthError", "not enough number of arguments for askForResource", null)
        }

        val readResources = inputs[0] as List<*>
        val writeResources = inputs[1] as List<*>

        val contract = vitalHealthConnectManager.createPermissionRequestContract(
            readResources = readResources.mapNotNullTo(mutableSetOf()) { runCatching { VitalResource.valueOf(it as String) }.getOrNull() },
            writeResources = writeResources.mapNotNullTo(mutableSetOf()) { runCatching { WritableVitalResource.valueOf(it as String) }.getOrNull() },
        )

        synchronized(this) {
            activeAskRequest = Pair(contract, result)
        }

        val registry = activity.activityResultRegistry
        val launcherRef = AtomicReference<ActivityResultLauncher<*>>(null)
        val launcher = registry.register("io.tryvital.health.ask", contract, ActivityResultCallback { activityResult ->
            val continuation = synchronized(this) {
                val currentValue = activeAskRequest
                activeAskRequest = null
                return@synchronized currentValue
            }

            val launcher = launcherRef.getAndSet(null)
            launcher?.unregister()

            if (continuation != null) {
                taskScope.launch {
                    val response = when (activityResult.await()) {
                        // Null = success
                        is PermissionOutcome.Success -> null
                        is PermissionOutcome.Failure -> JSONObject(
                            mapOf(
                                "code" to "failure",
                                "message" to "",
                            )
                        ).toString()
                        is PermissionOutcome.HealthConnectUnavailable -> JSONObject(
                            mapOf(
                                "code" to "healthKitNotAvailable",
                                "message" to "Health Connect is not available"
                            )
                        ).toString()
                    }
                    continuation.second.success(response)
                }
            }
        })
        launcherRef.set(launcher)
        launcher.launch(Unit)
    }

    private fun enableBackgroundSync(@Suppress("UNUSED_PARAMETER") call: MethodCall, result: Result) {
        val availability = VitalHealthConnectManager.isAvailable(context)
        if (availability != HealthConnectAvailability.Installed) {
            return result.error("VitalHealthError", "Health Connect is not available: $availability", null)
        }

        if (synchronized(this) { activeEnableBgSync != null }) {
            return result.error("VitalHealthError", "another ask request is in progress", null)
        }

        val activity = this.activity ?: return result.error("VitalHealthError", "No active Android Activity", null)
        if (activity !is ComponentActivity) {
            return result.error("VitalHealthError", "The MainActivity of your Flutter host app must be a `FlutterFragmentActivity` subclass for the permission request flow to function properly.", null)
        }

        val contract = vitalHealthConnectManager.enableBackgroundSyncContract()

        synchronized(this) {
            activeEnableBgSync = Pair(contract, result)
        }

        val registry = activity.activityResultRegistry
        val launcherRef = AtomicReference<ActivityResultLauncher<*>>(null)
        val launcher = registry.register("io.tryvital.health.enableBackgroundSync", contract) { success ->
            val continuation = synchronized(this) {
                val currentValue = activeEnableBgSync
                activeEnableBgSync = null
                return@synchronized currentValue
            }

            val launcher = launcherRef.getAndSet(null)
            launcher?.unregister()

            if (continuation != null) {
                taskScope.launch {
                    continuation.second.success(success)
                }
            }
        }
        launcherRef.set(launcher)
        launcher.launch(Unit)
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

    private fun setSyncNotificationContent(call: MethodCall, result: Result) = result.execute(taskScope) {
        val builder = VitalHealthConnectManager.syncNotificationBuilder(context)

        if (builder is DefaultSyncNotificationBuilder) {
            val json = JSONObject(call.arguments<String>()!!)

            builder.setContentOverride(
                DefaultSyncNotificationContent(
                    notificationTitle = json.getString("notificationTitle"),
                    notificationContent = json.getString("notificationContent"),
                    channelName = json.getString("channelName"),
                    channelDescription = json.getString("channelDescription"),
                )
            )
        }
        return@execute null
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
                        is SummaryData.MenstrualCycles -> {
                            throw NotImplementedError("Not supported")
                        }

                        is SummaryData.Meals -> {
                            throw NotImplementedError("Not supported")
                        }

                        is SummaryData.Profile -> {
                            JSONObject(
                                mapOf(
                                    "biologicalSex" to (readResult.summaryData as SummaryData.Profile).biologicalSex,
                                    "dateOfBirth" to (readResult.summaryData as SummaryData.Profile).dateOfBirth.toString(),
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
                                            put("startDate", it.startDate.toString())
                                            put("endDate", it.endDate.toString())
                                            put("sourceBundle", it.sourceBundle)
                                            put("deviceModel", it.deviceModel)
                                            put("sport", it.sport)
                                            put(
                                                "caloriesInKiloJules",
                                                it.calories
                                            )
                                            put("distanceInMeter", it.calories)
                                            put(
                                                "heartRate",
                                                JSONArray()
                                            )
                                            put(
                                                "respiratoryRate",
                                                JSONArray()
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
                                            put("startDate", it.startDate.toString())
                                            put("endDate", it.endDate.toString())
                                            put("sourceBundle", it.sourceBundle)
                                            put("deviceModel", it.deviceModel)
                                            put(
                                                "heartRate",
                                                JSONArray()
                                            )
                                            put(
                                                "restingHeartRate",
                                                JSONArray()
                                            )
                                            put(
                                                "heartRateVariability",
                                                JSONArray()
                                            )
                                            put(
                                                "oxygenSaturation",
                                                JSONArray()
                                            )
                                            put(
                                                "respiratoryRate",
                                                JSONArray()
                                            )
                                            put("sleepStages", JSONObject().apply {
                                                put(
                                                    "awakeSleepSamples",
                                                    it.sleepStages.awakeSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "deepSleepSamples",
                                                    it.sleepStages.deepSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "lightSleepSamples",
                                                    it.sleepStages.lightSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "remSleepSamples",
                                                    it.sleepStages.remSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "outOfBedSleepSamples",
                                                    it.sleepStages.outOfBedSleepSamples.map {
                                                        mapSampleToJson(it)
                                                    })
                                                put(
                                                    "unknownSleepSamples",
                                                    it.sleepStages.unknownSleepSamples.map {
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

    private fun configureHealthConnect(call: MethodCall, result: Result) {
        val manager = VitalHealthConnectManager.getOrCreate(context)
        val availability = VitalHealthConnectManager.isAvailable(context)

        if (availability != HealthConnectAvailability.Installed) {
            return result.error(
                "ClientSetup",
                "Health Connect is unavailable: $availability",
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

private fun mapSampleToJson(it: LocalQuantitySample): JSONObject {
    return JSONObject().apply {
        put("id", it.id)
        put("value", it.value)
        put("unit", it.unit)
        put("startDate", it.startDate.toString())
        put("endDate", it.endDate.toString())
        put("sourceBundle", it.sourceBundle)
        put("deviceModel", it.deviceModel)
        put("type", it.type)
    }
}

private inline fun Result.execute(scope: CoroutineScope, crossinline action: suspend () -> Any?) = scope.launch {
    try {
        val result = action()
        success(result)
    } catch (e: Throwable) {
        error("VitalHealthError", "${e::class.simpleName} ${e.message}", e.stackTraceToString())
    }
}

