import Flutter
import UIKit
import VitalCore
import VitalHealthKit

public class SwiftVitalFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vital_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftVitalFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("FlutterPlugin \(call.method) \(call.arguments)")
    
    switch call.method {
    case "configure":
      VitalClient.configure(
        apiKey: "sk_eu_S5LdXTS_CAtdFrkX9OYsiVq_jGHaIXtZyBPbBtPkzhA",
        environment: .sandbox(.eu)
      )
      VitalHealthKitClient.configure()
      result("OK")
      return
    case "setUserId":
      VitalClient.setUserId(UUID(uuidString: call.arguments as! String)!)
      result("OK")
      return
    case "askForResources":
      Task {
        let outcome = await VitalHealthKitClient.shared.ask(for: [.profile, .body])
        print("FlutterPlugin askForResources \(outcome)")
        result("OK")
      }
      return
    case "syncData":
      VitalHealthKitClient.shared.syncData(for: [.profile, .body])
      result("OK")
      return
    default:
      break
    }
    result("Failed")
  }
}
