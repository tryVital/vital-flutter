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
    Task {
      func reportInvalidArguments(context: String = "") {
        result(
          FlutterError(
            code: "InvalidArgument",
            message: "Invalid arguments for \(call.method)" + (context != "" ? ": \(context)" : ""),
            details: nil
          )
        )
      }

      func reportError(_ error: Error) {
        result(
          FlutterError(
            code: "VitalCoreError",
            message: error.localizedDescription,
            details: nil
          )
        )
      }

      switch call.method {
      case "setUserId":
        guard let argument = call.arguments as? String, let userId = UUID(uuidString: argument) else {
          return reportInvalidArguments()
        }
        await VitalClient.setUserId(userId)
        result(nil)

      case "configure":
        guard
          let arguments = call.arguments as? [String: AnyHashable],
          let rawEnvironment = arguments["environment"] as? String,
          let region = (arguments["region"] as? String).flatMap(Environment.Region.init(rawValue:)),
          let apiKey = arguments["apiKey"] as? String
        else { return reportInvalidArguments() }

        let environment: Environment
        switch rawEnvironment {
        case "dev":
          environment = .dev(region)
        case "sandbox":
          environment = .sandbox(region)
        case "production":
          environment = .production(region)
        default:
          reportInvalidArguments(context: "unknown environment: \(rawEnvironment)")
          return
        }

        await VitalClient.configure(apiKey: apiKey, environment: environment)
        result(nil)

      case "signIn":
        guard
          let arguments = call.arguments as? [String: AnyHashable],
          let signInToken = arguments["signInToken"] as? String
        else { return reportInvalidArguments() }

        do {
          try await VitalClient.signIn(withRawToken: signInToken)
          result(nil)

        } catch let error {
          reportError(error)
        }

      case "hasUserConnectedTo":
        guard
          let arguments = call.arguments as? [String: AnyHashable],
          let rawProvider = arguments["provider"] as? String
        else { return reportInvalidArguments() }

        guard let provider = Provider.Slug(rawValue: rawProvider)
          else { return reportInvalidArguments(context: "unrecognized provider \(rawProvider)") }

        do {
          result(try await VitalClient.shared.isUserConnected(to: provider))

        } catch let error {
          reportError(error)
        }

      case "userConnectedSources":
        do {
          let providers = try await VitalClient.shared.user.userConnectedSources()
            .map { ["name": $0.name, "slug": $0.slug.rawValue, "logo": $0.logo] }
          let jsonString = String(data: try JSONEncoder().encode(providers), encoding: .utf8)!
          // NOTE: Dart end expects a JSON string
          result(jsonString)

        } catch let error {
          reportError(error)
        }

      case "createConnectedSourceIfNotExist":
        guard
          let arguments = call.arguments as? [String: AnyHashable],
          let rawProvider = arguments["provider"] as? String
        else { return reportInvalidArguments() }

        guard let provider = Provider.Slug(rawValue: rawProvider)
          else { return reportInvalidArguments(context: "unrecognized provider \(rawProvider)") }

        do {
          try await VitalClient.shared.checkConnectedSource(for: provider)
          result(nil)

        } catch let error {
          reportError(error)
        }

      case "deregisterProvider":
        guard
          let arguments = call.arguments as? [String: AnyHashable],
          let rawProvider = arguments["provider"] as? String
        else { return reportInvalidArguments() }

        guard let provider = Provider.Slug(rawValue: rawProvider)
          else { return reportInvalidArguments(context: "unrecognized provider \(rawProvider)") }

        do {
          try await VitalClient.shared.user.deregisterProvider(provider: provider)
          result(nil)

        } catch let error {
          reportError(error)
        }

      case "cleanUp":
        await VitalClient.shared.cleanUp()
        result(nil)

      default:
        result(
          FlutterError(
            code: "UnsupportedMethod",
            message: "Method not supported \(call.method)",
            details: nil
          )
        )
      }
    }
  }
}
