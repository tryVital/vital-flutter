import Flutter
import UIKit
import VitalCore

public class SwiftVitalCorePlugin: NSObject, FlutterPlugin {
    private let channel: FlutterMethodChannel

    private var flutterRunning = true

    init(_ channel: FlutterMethodChannel){
        self.channel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vital_core", binaryMessenger: registrar.messenger())
        let instance = SwiftVitalCorePlugin(channel)

        registrar.publish(instance)

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        flutterRunning = false
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        flutterRunning = false
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterError.init(code: "Unsupported method",
                                 message: "Method not supported \(call.method)",
                                 details: nil))
    }

}
