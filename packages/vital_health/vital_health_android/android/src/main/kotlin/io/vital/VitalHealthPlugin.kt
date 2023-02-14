package io.vital

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.*
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
import io.tryvital.vitalhealthconnect.model.HealthResource
import io.tryvital.vitalhealthconnect.model.SyncStatus
import io.tryvital.vitalhealthconnect.model.processedresource.ProcessedResourceData
import io.tryvital.vitalhealthconnect.model.processedresource.QuantitySample
import io.tryvital.vitalhealthconnect.model.processedresource.SummaryData
import io.tryvital.vitalhealthconnect.model.processedresource.TimeSeriesData
import kotlinx.coroutines.*
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant
import kotlin.reflect.KClass

/** VitalHealthPlugin */
class VitalHealthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private val logger = VitalLogger.getOrCreate()

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    private var vitalClient: VitalClient? = null
    private var vitalHealthConnectManager: VitalHealthConnectManager? = null
    private var activity: Activity? = null

    private var askForResourcesResult: Result? = null
    private var askedHealthPermissions: Set<HealthPermission>? = null

    private var mainScope: CoroutineScope? = null
    private var statusScope: CoroutineScope? = null
    private var writeScope: CoroutineScope? = null
    private var readScope: CoroutineScope? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_health_connect")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    private fun startStatusUpdate() {
        statusScope?.cancel()
        statusScope = MainScope()
        statusScope?.launch {
            try {
                withContext(Dispatchers.Default) {
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
        statusScope?.cancel()
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
        val readResources = call.argument<List<String>>("readResources") ?: emptyList()
        val writeResources = call.argument<List<String>>("writeResources") ?: emptyList()

        val requestPermissionActivityContract =
            PermissionController.createRequestPermissionResultContract()
        val healthPermissions = readResources.map { mapReadResourceToHealthRecord(it) }.flatten()
            .map { HealthPermission.createReadPermission(it) }.toSet().plus(
                writeResources.map { mapWriteResourceToHealthRecord(it) }.flatten()
                    .map { HealthPermission.createWritePermission(it) }.toSet()
            )

        askForResourcesResult = result
        askedHealthPermissions = healthPermissions
        activity?.startActivityForResult(
            requestPermissionActivityContract.createIntent(
                context,
                healthPermissions
            ), 666
        )
    }

    override fun onActivityResult(p0: Int, p1: Int, p2: Intent?): Boolean {
        if (p0 == 666) {
            mainScope?.cancel()
            mainScope = MainScope()
            mainScope!!.launch {
                val grantedPermissions =
                    vitalHealthConnectManager!!.getGrantedPermissions(context).toSet()

                val notGrantedPermissions = (askedHealthPermissions
                    ?: emptySet()).filter { !grantedPermissions.contains(it) }

                if (notGrantedPermissions.isEmpty()) {
                    askForResourcesResult?.success(true)
                } else {
                    vitalClient?.vitalLogger?.logI("Not granted permissions: $notGrantedPermissions")
                    askForResourcesResult?.success(false)
                }
                askedHealthPermissions = null
                askForResourcesResult = null
            }
            return true
        }
        return false
    }

    private fun writeHealthData(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "ClientSetup",
                "VitalHealthConnect is not configured",
                null
            )
            return
        }

        writeScope?.cancel()
        writeScope = MainScope()
        writeScope!!.launch {
            try {
                vitalHealthConnectManager!!.addHealthResource(
                    mapStringToHealthResource(
                        call.argument<String>(
                            "resource"
                        )!!
                    )!!,
                    startDate = Instant.ofEpochMilli(call.argument("startDate")!!),
                    endDate = Instant.ofEpochMilli(call.argument("endDate")!!),
                    value = call.argument("value")!!,
                )
            } catch (e: Exception) {
                result.error(
                    "Unknown",
                    e.message,
                    e
                )
            }
        }
    }

    private fun read(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "ClientSetup",
                "VitalHealthConnect is not configured",
                null
            )
            return
        }

        readScope?.cancel()
        readScope = MainScope()
        readScope!!.launch {
            try {
                val readResult = vitalHealthConnectManager!!.read(
                    mapStringToHealthResource(
                        call.argument<String>(
                            "resource"
                        )!!
                    )!!,
                    startDate = Instant.ofEpochMilli(call.argument("startDate")!!),
                    endDate = Instant.ofEpochMilli(call.argument("endDate")!!),
                )

                when (readResult) {
                    is ProcessedResourceData.Summary -> {
                        when (readResult.summaryData) {
                            is SummaryData.Profile -> {
                                result.success(
                                    JSONObject(
                                        mapOf(
                                            "biologicalSex" to (readResult.summaryData as SummaryData.Profile).biologicalSex,
                                            "dateOfBirth" to (readResult.summaryData as SummaryData.Profile).dateOfBirth.time,
                                            "heightInCm" to (readResult.summaryData as SummaryData.Profile).heightInCm,
                                        )
                                    ).toString()
                                )
                            }
                            is SummaryData.Body -> {
                                result.success(
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
                                )
                            }
                            is SummaryData.Activities -> {
                                result.success(
                                    JSONObject(
                                        mapOf(
                                            "activities" to JSONArray((readResult.summaryData as SummaryData.Activities).samples.map {
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
                                )
                            }
                            is SummaryData.Workouts -> {
                                result.success(
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
                                )
                            }
                            is SummaryData.Sleeps -> {
                                result.success(
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
                                )
                            }
                        }
                    }
                    is ProcessedResourceData.TimeSeries -> {
                        when (readResult.timeSeriesData) {
                            is TimeSeriesData.Glucose -> result.success(
                                JSONObject(
                                    mapOf(
                                        "timeSeries" to JSONArray((readResult.timeSeriesData as TimeSeriesData.Glucose).samples.map {
                                            mapSampleToJson(it)
                                        }),
                                    )
                                ).toString()
                            )
                            is TimeSeriesData.BloodPressure -> {
                                result.success(
                                    JSONObject(
                                        mapOf(
                                            "timeSeries" to JSONArray((readResult.timeSeriesData as TimeSeriesData.BloodPressure).samples.map {
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
                                )
                            }
                            is TimeSeriesData.HeartRate -> result.success(
                                JSONObject(
                                    mapOf(
                                        "timeSeries" to JSONArray((readResult.timeSeriesData as TimeSeriesData.HeartRate).samples.map {
                                            mapSampleToJson(it)
                                        }),
                                    )
                                ).toString()
                            )
                            is TimeSeriesData.HeartRateVariabilityRmssd -> result.success(
                                JSONObject(
                                    mapOf(
                                        "timeSeries" to JSONArray((readResult.timeSeriesData as TimeSeriesData.HeartRateVariabilityRmssd).samples.map {
                                            mapSampleToJson(it)
                                        }),
                                    )
                                ).toString()
                            )
                            is TimeSeriesData.Water -> result.success(
                                JSONObject(
                                    mapOf(
                                        "timeSeries" to JSONArray((readResult.timeSeriesData as TimeSeriesData.Water).samples.map {
                                            mapSampleToJson(it)
                                        }),
                                    )
                                ).toString()
                            )
                        }
                    }
                }
            } catch (e: Exception) {
                result.error(
                    "Unknown",
                    e.message,
                    e
                )
            }
        }

    }

    private fun syncData(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "ClientSetup",
                "VitalHealthConnect is not configured",
                null
            )
            return
        }

        mainScope?.cancel()
        mainScope = MainScope()
        mainScope!!.launch {
            val resources = call.argument<List<String>>("resources") ?: emptyList()

            vitalHealthConnectManager!!.syncData(
                resources.mapNotNull { mapStringToHealthResource(it) }.toSet()
            )
        }
    }

    private fun setUserId(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "ClientSetup",
                "VitalHealthConnect is not configured",
                null
            )
            return
        }

        mainScope?.cancel()
        mainScope = MainScope()
        mainScope!!.launch {
            vitalHealthConnectManager!!.setUserId(call.argument<String?>("userId")!!)
            result.success(null)
        }
    }

    private fun configureHealthConnect(call: MethodCall, result: Result) {
        if (vitalClient == null) {
            return result.error("ClientSetup", "VitalClient is not configured", null)
        }

        val manager = VitalHealthConnectManager.create(
            context,
            vitalClient!!.apiKey,
            vitalClient!!.region,
            vitalClient!!.environment
        )
        val availability = manager.isAvailable(context)

        if (availability != HealthConnectAvailability.Installed) {
            return result.error(
                "ClientSetup",
                "Health Connect is unavailable: ${availability}",
                null
            )
        }

        vitalHealthConnectManager = manager

        mainScope?.cancel()
        mainScope = MainScope().apply {
            launch {
                manager.configureHealthConnectClient(
                    logsEnabled = call.argument<Boolean?>("logsEnabled")!!,
                    syncOnAppStart = call.argument<Boolean?>("syncOnAppStart")!!,
                    numberOfDaysToBackFill = call.argument<Int?>("numberOfDaysToBackFill")!!,
                )
                result.success(null)
            }
        }

        startStatusUpdate()
    }

    private fun configureClient(call: MethodCall, result: Result) {
        vitalClient = VitalClient(
            context,
            stringToRegion(call.argument("region")!!),
            stringToEnvironment(call.argument("environment")!!),
            call.argument<String>("apiKey")!!
        )

        result.success(null)
    }

    private fun cleanUp(result: Result) {
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

private fun stringToRegion(region: String): Region {
    when (region) {
        "eu" -> return Region.EU
        "us" -> return Region.US
    }

    throw Exception("Unsupported region $region")
}

private fun stringToEnvironment(environment: String): Environment {
    when (environment) {
        "production" -> return Environment.Production
        "sandbox" -> return Environment.Sandbox
        "dev" -> return Environment.Dev
    }

    throw Exception("Unsupported environment $environment")
}

private fun mapReadResourceToHealthRecord(resource: String): List<KClass<out Record>> {
    when (resource) {
        "profile" -> return listOf(HeightRecord::class, WeightRecord::class)
        "body" -> return listOf(BodyFatRecord::class)
        "workout" -> return listOf(ExerciseSessionRecord::class)
        "activity" -> return listOf(
            ActiveCaloriesBurnedRecord::class,
            BasalMetabolicRateRecord::class,
            StepsRecord::class,
            DistanceRecord::class,
            FloorsClimbedRecord::class,
            Vo2MaxRecord::class
        )
        "sleep" -> return listOf(SleepSessionRecord::class)
        "glucose" -> return listOf(BloodGlucoseRecord::class)
        "bloodPressure" -> return listOf(BloodPressureRecord::class)
        "heartRate" -> return listOf(HeartRateRecord::class)
        "heartRateVariability" -> return listOf(HeartRateVariabilityRmssdRecord::class)
        "steps" -> return listOf(StepsRecord::class)
        "activeEnergyBurned" -> return listOf(ActiveCaloriesBurnedRecord::class)
        "basalEnergyBurned" -> return listOf(BasalMetabolicRateRecord::class)
        "water" -> return listOf(HydrationRecord::class)
    }
    return listOf()
}

private fun mapWriteResourceToHealthRecord(resource: String): List<KClass<out Record>> {
    when (resource) {
        "water" -> return listOf(HydrationRecord::class)
    }

    return listOf()
}


private fun mapStringToHealthResource(resource: String): HealthResource? {
    return when (resource) {
        "profile" -> return HealthResource.Profile
        "body" -> return HealthResource.Body
        "workout" -> return HealthResource.Workout
        "activity" -> return HealthResource.Activity
        "sleep" -> return HealthResource.Sleep
        "glucose" -> return HealthResource.Glucose
        "bloodPressure" -> return HealthResource.BloodPressure
        "heartRate" -> return HealthResource.HeartRate
        "heartRateVariability" -> return HealthResource.HeartRateVariability
        "steps" -> return HealthResource.Steps
        "activeEnergyBurned" -> return HealthResource.ActiveEnergyBurned
        "basalEnergyBurned" -> return HealthResource.BasalEnergyBurned
        "water" -> return HealthResource.Water
        else -> null
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


