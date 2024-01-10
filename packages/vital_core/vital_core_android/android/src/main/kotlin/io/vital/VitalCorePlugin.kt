package io.vital

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.tryvital.client.Environment
import io.tryvital.client.Region
import io.tryvital.client.VitalClient
import io.tryvital.client.createConnectedSourceIfNotExist
import io.tryvital.client.getAccessToken
import io.tryvital.client.hasUserConnectedTo
import io.tryvital.client.refreshToken
import io.tryvital.client.services.data.ManualProviderSlug
import io.tryvital.client.services.data.ProviderSlug
import io.tryvital.client.userConnectedSources
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.addJsonObject
import kotlinx.serialization.json.buildJsonArray
import kotlinx.serialization.json.put

/** VitalCorePlugin */
class VitalCorePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private lateinit var taskScope: CoroutineScope

    private var statusJob: Job? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        taskScope = CoroutineScope(SupervisorJob())

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vital_core")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        taskScope.cancel()
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        fun reportInvalidArguments(context: String = "") {
            result.error(
                "InvalidArgument",
                "Invalid arguments for ${call.method}" + if(context != "") ": $context" else "",
                null
            )
        }

        fun reportError(error: Throwable) {
            result.error("VitalCoreError", "${error::class.simpleName} ${error.message}", null)
        }

        when (call.method) {
            "sdkVersion" -> {
                result.success(VitalClient.sdkVersion)
            }

            "currentUserId" -> {
                VitalClient.getOrCreate(context)
                result.success(VitalClient.currentUserId)
            }

            "setUserId" -> {
                val userId = call.arguments as? String ?: return reportInvalidArguments()

                VitalClient.setUserId(context, userId)
                result.success(null)
            }

            "configure" -> {
                val arguments = call.arguments as? Map<*, *> ?: return reportInvalidArguments()
                val rawEnvironment = arguments["environment"] as? String ?: return reportInvalidArguments()
                val rawRegion = arguments["region"] as? String ?: return reportInvalidArguments()
                val apiKey = arguments["apiKey"] as? String ?: return reportInvalidArguments()

                try {
                    VitalClient.configure(
                        context,
                        Region.valueOf(rawRegion.uppercase()),
                        Environment.valueOf(rawEnvironment.replaceFirstChar { it.uppercase() }),
                        apiKey,
                    )
                } catch (e: Throwable) {
                    reportError(e)
                }
            }

            "signIn" -> {
                val arguments = call.arguments as? Map<*, *> ?: return reportInvalidArguments()
                val signInToken = arguments["signInToken"] as? String ?: return reportInvalidArguments()

                taskScope.launch {
                    try {
                        VitalClient.signIn(context, signInToken)
                        withContext(Dispatchers.Main) {
                            result.success(null)
                        }

                    } catch (e: Throwable) {
                        withContext(Dispatchers.Main) {
                            reportError(e)
                        }
                    }
                }
            }

            "hasUserConnectedTo" -> {
                val arguments = call.arguments as? Map<*, *> ?: return reportInvalidArguments()
                val rawProvider = arguments ["provider"] as? String ?: return reportInvalidArguments()
                val provider = runCatching { ProviderSlug.valueOf(rawProvider) }.getOrNull()
                    ?: return reportInvalidArguments("unrecognized provider $rawProvider")

                try {
                    result.success(VitalClient.getOrCreate(context).hasUserConnectedTo(provider))

                } catch (e: Throwable) {
                    reportError(e)
                }
            }

            "userConnectedSources" -> {
                taskScope.launch {
                    try {
                        val jsonArray = buildJsonArray {
                            VitalClient.getOrCreate(context).userConnectedSources().forEach {
                                addJsonObject {
                                    put("name", it.name)
                                    put("slug", it.slug.toString())
                                    put("logo", it.logo)
                                }
                            }
                        }

                        val jsonString = Json.encodeToString(JsonArray.serializer(), jsonArray)
                        // NOTE: Dart end expects a JSON string
                        withContext(Dispatchers.Main) {
                            result.success(jsonString)
                        }

                    } catch (e: Throwable) {
                        withContext(Dispatchers.Main) {
                            reportError(e)
                        }
                    }
                }
            }

            "createConnectedSourceIfNotExist" -> {
                val arguments = call.arguments as? Map<*, *> ?: return reportInvalidArguments()
                val rawProvider = arguments ["provider"] as? String ?: return reportInvalidArguments()
                val provider = runCatching { ManualProviderSlug.valueOf(rawProvider) }.getOrNull()
                    ?: return reportInvalidArguments("unrecognized SDK provider $rawProvider")

                taskScope.launch {
                    try {
                        VitalClient.getOrCreate(context).createConnectedSourceIfNotExist(provider)

                        withContext(Dispatchers.Main) {
                            result.success(null)
                        }

                    } catch (e: Throwable) {
                        withContext(Dispatchers.Main) {
                            reportError(e)
                        }
                    }
                }
            }

            "deregisterProvider" -> {
                val arguments = call.arguments as? Map<*, *> ?: return reportInvalidArguments()
                val rawProvider = arguments ["provider"] as? String ?: return reportInvalidArguments()
                val provider = runCatching { ProviderSlug.valueOf(rawProvider) }.getOrNull()
                    ?: return reportInvalidArguments("unrecognized provider $rawProvider")

                taskScope.launch {
                    try {
                        val userId = VitalClient.getOrCreate(context).checkUserId()
                        VitalClient.getOrCreate(context).userService.deregisterProvider(userId, provider)
                        withContext(Dispatchers.Main) {
                            result.success(null)
                        }

                    } catch (e: Throwable) {
                        withContext(Dispatchers.Main) {
                            reportError(e)
                        }
                    }
                }
            }

            "cleanUp" -> {
                try {
                    VitalClient.getOrCreate(context).cleanUp()
                    result.success(null)
                } catch (e: Throwable) {
                    reportError(e)
                }
            }

            "getAccessToken" -> {
                taskScope.launch {
                    try {
                        val accessToken = VitalClient.getAccessToken(context)
                        result.success(accessToken)
                    } catch (e: Throwable) {
                        reportError(e)
                    }
                }
            }

            "refreshToken" -> {
                taskScope.launch {
                    try {
                        VitalClient.refreshToken(context)
                        result.success(null)
                    } catch (e: Throwable) {
                        reportError(e)
                    }
                }
            }

            "clientStatus" -> {
                VitalClient.getOrCreate(context)
                // lowerCamelCase to match iOS.
                val statuses = VitalClient.status.map { status -> status.name.replaceFirstChar { it.lowercase() } }
                result.success(statuses)
            }

            "subscribeToStatusChanges" -> {
                statusJob = taskScope.launch(Dispatchers.Main) {
                    VitalClient.statusChanged(context).collect {
                        channel.invokeMethod("statusDidChange", null)
                    }
                }
            }

            "unsubscribeFromStatusChanges" -> {
                statusJob?.cancel()
                statusJob = null
            }

            else -> {
                result.error("UnsupportedMethod", "Method not supported ${call.method}", null)
            }
        }
    }
}
