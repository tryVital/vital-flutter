package io.vital

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.tryvital.client.utils.VitalLogger
import io.tryvital.vitaldevices.Brand
import io.tryvital.vitaldevices.DeviceModel
import io.tryvital.vitaldevices.Kind
import io.tryvital.vitaldevices.VitalDeviceManager
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.flowOn
import org.json.JSONObject

/** VitalFlutterPlugin */
class VitalFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private lateinit var vitalDeviceManager: VitalDeviceManager

    private var mainScope: CoroutineScope? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_devices")
        vitalDeviceManager = VitalDeviceManager(flutterPluginBinding.applicationContext)
        VitalLogger.create().enabled = true
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
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
                throw Exception("Not implemented")
            }
            "pair" -> {
                throw Exception("Not implemented")
            }
            "startReadingGlucoseMeter" -> {
                throw Exception("Not implemented")
            }
            "startReadingBloodPressure" -> {
                throw Exception("Not implemented")
            }
            "cleanUp" -> {
                throw Exception("Not implemented")
            }
            else -> throw  Exception("Unsupported method")
        }
    }

    private suspend fun startScanForDevice(arguments: List<String>) {
        val deviceModel = DeviceModel(
            id = arguments[0],
            name = arguments[1],
            brand = stringToBrand(arguments[2]),
            kind = stringToKind(arguments[3]),
        )

        vitalDeviceManager.search(deviceModel)
            .flowOn(Dispatchers.IO)
            .collect {
                withContext(Dispatchers.Main) {
                    val function = mapOf(
                        "id" to it.address,
                        "name" to it.name,
                        "deviceModel" to mapOf(
                            "id" to it.deviceModel.id,
                            "name" to it.deviceModel.name,
                            "brand" to brandToString(it.deviceModel.brand),
                            "kind" to kindToString(it.deviceModel.kind)
                        )
                    )
                    channel.invokeMethod("sendScan", JSONObject(function).toString())
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

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
