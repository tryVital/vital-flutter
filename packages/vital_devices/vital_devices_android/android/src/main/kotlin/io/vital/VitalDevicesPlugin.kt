package io.vital

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.tryvital.client.services.data.QuantitySamplePayload
import io.tryvital.client.utils.VitalLogger
import io.tryvital.vitaldevices.*
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flowOn
import org.json.JSONArray
import org.json.JSONObject

/** VitalDevicesPlugin */
class VitalDevicesPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private lateinit var vitalDeviceManager: VitalDeviceManager

    private val scannedDevices: MutableList<ScannedDevice> = mutableListOf()

    private var mainScope: CoroutineScope? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_devices")
        vitalDeviceManager = VitalDeviceManager(flutterPluginBinding.applicationContext)
        VitalLogger.getOrCreate().enabled = true
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startScanForDevice" -> {
                mainScope?.cancel()
                mainScope = MainScope()
                mainScope?.launch {
                    withContext(Dispatchers.Default) {
                        startScanForDevice(
                            call.arguments<List<String>>()!!
                        )
                    }
                }

                result.success(null)
            }

            "stopScanForDevice" -> {
                mainScope?.cancel()
                result.success(null)
            }

            "pair" -> {
                pair(call.arguments<List<String>>()!!.first(), result)
            }

            "startReadingGlucoseMeter" -> {
                startReadingGlucoseMeter(call.arguments<List<String>>()!!.first(), result)
            }

            "startReadingBloodPressure" -> {
                startReadingBloodPressure(call.arguments<List<String>>()!!.first(), result)
            }

            "cleanUp" -> {
                mainScope?.cancel()
                scannedDevices.clear()
                result.success(null)
            }

            else -> throw Exception("Unsupported method ${call.method}")
        }
    }

    private fun pair(scannedDeviceId: String, result: Result) {
        val scannedDevice = scannedDevices.firstOrNull { it.address == scannedDeviceId }

        if (scannedDevice == null) {
            result.error("DeviceNotFound", "Device $scannedDeviceId not found", null)
        } else {
            mainScope?.cancel()
            mainScope = MainScope()
            mainScope?.launch {
                try {
                    withContext(Dispatchers.Default) {
                        vitalDeviceManager.pair(scannedDevice).collect {
                            withContext(Dispatchers.Main) {
                                channel.invokeMethod("sendPair", it.toString())
                            }
                        }
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        channel.invokeMethod(
                            "sendPair", JSONObject(
                                mapOf(
                                    "code" to "PairError",
                                    "message" to e.message,
                                )
                            ).toString()
                        )
                    }
                }
            }
            result.success(null)
        }
    }

    private fun startReadingGlucoseMeter(scannedDeviceId: String, result: Result) {
        val scannedDevice = scannedDevices.firstOrNull { it.address == scannedDeviceId }

        if (scannedDevice == null) {
            result.error("DeviceNotFound", "Device $scannedDeviceId not found", null)
        } else {
            mainScope?.cancel()
            mainScope = MainScope()
            mainScope?.launch {
                try {
                    withContext(Dispatchers.Default) {
                        vitalDeviceManager.glucoseMeter(context, scannedDevice)
                            .flowOn(Dispatchers.IO)
                            .collect { samples ->
                                withContext(Dispatchers.Main) {
                                    channel.invokeMethod(
                                        "sendGlucoseMeterReading",
                                        JSONArray(samples.map { mapSample(it) }).toString()
                                    )
                                }
                            }
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        channel.invokeMethod(
                            "sendGlucoseMeterReading", JSONObject(
                                mapOf(
                                    "code" to "GlucoseMeterReadingError",
                                    "message" to e.message,
                                )
                            ).toString()
                        )
                    }

                }
            }

            result.success(null)
        }
    }

    private fun startReadingBloodPressure(scannedDeviceId: String, result: Result) {
        val scannedDevice = scannedDevices.firstOrNull { it.address == scannedDeviceId }

        if (scannedDevice == null) {
            result.error("DeviceNotFound", "Device $scannedDeviceId not found", null)
        } else {
            mainScope?.cancel()
            mainScope = MainScope()
            mainScope?.launch {
                try {
                    withContext(Dispatchers.Default) {
                        vitalDeviceManager.bloodPressure(context, scannedDevice)
                            .flowOn(Dispatchers.IO)
                            .collect { samples ->
                                withContext(Dispatchers.Main) {
                                    channel.invokeMethod(
                                        "sendBloodPressureReading",
                                        JSONArray(samples.map {
                                            JSONObject().apply {
                                                put("systolic", mapSample(it.systolic))
                                                put("diastolic", mapSample(it.diastolic))
                                                put("pulse", mapSample(it.pulse))
                                            }
                                        }).toString()
                                    )
                                }
                            }
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        channel.invokeMethod(
                            "sendBloodPressureReading", JSONObject(
                                mapOf(
                                    "code" to "BloodPressureReadingError",
                                    "message" to e.message,
                                )
                            ).toString()
                        )
                    }

                }
            }

            result.success(null)
        }

    }

    private suspend fun startScanForDevice(arguments: List<String>) {
        val deviceModel = DeviceModel(
            id = arguments[0],
            name = arguments[1],
            brand = stringToBrand(arguments[2]),
            kind = stringToKind(arguments[3]),
        )

        try {
            vitalDeviceManager.search(deviceModel).flowOn(Dispatchers.IO).collect {
                withContext(Dispatchers.Main) {
                    scannedDevices.add(it)
                    channel.invokeMethod(
                        "sendScan", JSONObject(
                            mapOf(
                                "id" to it.address, "name" to it.name, "deviceModel" to mapOf(
                                    "id" to it.deviceModel.id,
                                    "name" to it.deviceModel.name,
                                    "brand" to brandToString(it.deviceModel.brand),
                                    "kind" to kindToString(it.deviceModel.kind)
                                )
                            )
                        ).toString()
                    )
                }
            }
        } catch (e: Exception) {
            withContext(Dispatchers.Main) {
                channel.invokeMethod(
                    "sendScan", JSONObject(
                        mapOf(
                            "code" to "UnknownError",
                            "message" to e.message,
                        )
                    ).toString()
                )
            }
        }
    }

    private fun kindToString(kind: Kind): String {
        return when (kind) {
            Kind.GlucoseMeter -> "glucoseMeter"
            Kind.BloodPressure -> "bloodPressure"
        }
    }

    private fun brandToString(brand: Brand): String {
        return when (brand) {
            Brand.Omron -> "omron"
            Brand.AccuChek -> "accuChek"
            Brand.Contour -> "contour"
            Brand.Beurer -> "beurer"
            Brand.Libre -> "libre"
        }
    }

    private fun stringToBrand(string: String): Brand {
        return when (string) {
            "omron" -> Brand.Omron
            "accuChek" -> Brand.AccuChek
            "contour" -> Brand.Contour
            "beurer" -> Brand.Beurer
            "libre" -> Brand.Libre
            else -> throw Exception("Unsupported brand")
        }
    }

    private fun stringToKind(string: String): Kind {
        return when (string) {
            "bloodPressure" -> Kind.BloodPressure
            "glucoseMeter" -> Kind.GlucoseMeter
            else -> throw Exception("Unsupported kind")
        }
    }

    private fun mapSample(it: QuantitySamplePayload): JSONObject {
        return JSONObject().apply {
            put("id", it.id)
            put("value", it.value)
            put("unit", it.unit)
            put("startDate", it.startDate.time)
            put("endDate", it.endDate.time)
            put("type", it.type)
        }
    }
}
