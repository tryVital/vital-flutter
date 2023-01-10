package io.vital

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.tryvital.client.utils.VitalLogger
import kotlinx.coroutines.*

/** VitalDevicesPlugin */
class VitalHealthPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    private var mainScope: CoroutineScope? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_health_connect")
        VitalLogger.create().enabled = true
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "startScanForDevice" -> {
            }

            "stopScanForDevice" -> {
            }

            "pair" -> {
            }

            "startReadingGlucoseMeter" -> {
            }

            "startReadingBloodPressure" -> {
            }

            "cleanUp" -> {
            }

            else -> throw Exception("Unsupported method ${call.method}")
        }
    }
}
