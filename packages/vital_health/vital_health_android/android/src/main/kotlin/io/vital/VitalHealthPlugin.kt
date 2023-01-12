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
import io.flutter.plugin.common.PluginRegistry
import io.tryvital.client.Environment
import io.tryvital.client.Region
import io.tryvital.client.VitalClient
import io.tryvital.client.utils.VitalLogger
import io.tryvital.vitalhealthconnect.VitalHealthConnectManager
import io.tryvital.vitalhealthconnect.model.SyncStatus
import kotlinx.coroutines.*
import kotlin.reflect.KClass
import io.flutter.plugin.common.MethodChannel.Result

/** VitalHealthPlugin */
class VitalHealthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    private val logger = VitalLogger.create()

    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    private var vitalClient: VitalClient? = null
    private var vitalHealthConnectManager: VitalHealthConnectManager? = null
    private var mainScope: CoroutineScope? = null
    private var statusScope: CoroutineScope? = null
    private var activity: Activity? = null

    private var askForResourcesResult: Result? = null
    private var askedHealthPermissions: Set<HealthPermission>? = null

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
                                SyncStatus.FailedSyncing -> channel.invokeMethod(
                                    "status",
                                    listOf("failedSyncing", "profile")
                                )
                                SyncStatus.NothingToSync -> channel.invokeMethod(
                                    "status",
                                    listOf("nothingToSync","profile")
                                )
                                SyncStatus.Syncing -> channel.invokeMethod(
                                    "status",
                                    listOf("syncing","profile")
                                )
                                SyncStatus.SyncingCompleted -> channel.invokeMethod(
                                    "status",
                                    listOf("syncingCompleted","profile")
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
                        "unknown", listOf("failedSyncing",)
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
                cleanUp(call, result)
            }

            else -> throw Exception("Unsupported method ${call.method}")
        }
    }

    private fun askForResources(call: MethodCall, result: Result) {
        val resources = call.argument<List<String>>("readResources") ?: emptyList<String>()

        val requestPermissionActivityContract =
            PermissionController.createRequestPermissionResultContract()
        val healthPermissions = resources.map { mapResourceToHealthRecord(it) }.flatten()
            .map { HealthPermission.createReadPermission(it) }.toSet()

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
                if (askedHealthPermissions?.containsAll(
                        vitalHealthConnectManager!!.getGrantedPermissions(
                            context
                        ).toSet()
                    ) == true
                ) {
                    askForResourcesResult?.success(true)
                } else {
                    askForResourcesResult?.success(false)
                }
                askedHealthPermissions = null
                askForResourcesResult = null
            }
            return true
        }
        return false
    }

    private fun syncData(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "VitalHealthConnect is configured",
                "VitalHealthConnect is configured",
                null
            )
            return
        }

        mainScope?.cancel()
        mainScope = MainScope()
        mainScope!!.launch {
            vitalHealthConnectManager!!.syncData(
                vitalHealthConnectManager!!.getGrantedPermissions(
                    context
                )
            )
        }
    }

    private fun setUserId(call: MethodCall, result: Result) {
        if (vitalHealthConnectManager == null) {
            result.error(
                "VitalHealthConnect is configured",
                "VitalHealthConnect is configured",
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
            result.error("VitalClient is not configured", "VitalClient is not configured", null)
        }

        vitalHealthConnectManager = VitalHealthConnectManager.create(
            context,
            vitalClient!!.apiKey,
            vitalClient!!.region,
            vitalClient!!.environment
        )

        mainScope?.cancel()
        mainScope = MainScope()
        mainScope!!.launch {
            vitalHealthConnectManager!!.configureHealthConnectClient(
                logsEnabled = call.argument<Boolean?>("logsEnabled")!!,
                syncOnAppStart = call.argument<Boolean?>("syncOnAppStart")!!,
                numberOfDaysToBackFill = call.argument<Int?>("numberOfDaysToBackFill")!!,
            )
        }

        startStatusUpdate()

        result.success(null)
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

    private fun cleanUp(call: MethodCall, result: Result) {
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

private fun mapResourceToHealthRecord(resource: String): List<KClass<out Record>> {
    when (resource) {
        "profile" -> return listOf(HeightRecord::class, WeightRecord::class)
        "body" -> return listOf(BodyFatRecord::class)
        "workout" -> return listOf(ExerciseSessionRecord::class)
        "activity" -> return listOf()
        "sleep" -> return listOf(SleepSessionRecord::class)
        "glucose" -> return listOf(BloodGlucoseRecord::class) // TODO this is missing in android
        "bloodPressure" -> return listOf(BloodPressureRecord::class)
        "heartRate" -> return listOf(HeartRateVariabilitySdnnRecord::class)
        "steps" -> return listOf(StepsRecord::class)
        "activeEnergyBurned" -> return listOf(ActiveCaloriesBurnedRecord::class)
        "basalEnergyBurned" -> return listOf(BasalMetabolicRateRecord::class)
        "water" -> return listOf()
    }
    return listOf()
}
