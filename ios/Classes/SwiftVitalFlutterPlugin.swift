import Flutter
import UIKit
import Combine
import VitalCore
import VitalHealthKit

public class SwiftVitalFlutterPlugin: NSObject, FlutterPlugin {

  init(_ channel: FlutterMethodChannel){
    self.channel = channel;
  }

  private var cancellable: Cancellable? = nil
  private let channel: FlutterMethodChannel

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vital_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftVitalFlutterPlugin(channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("FlutterPlugin \(String(describing: call.method)) \(call.arguments ?? nil)")
    
    switch call.method {
    case "configure":
      configure(call.arguments as! [String], result: result)
      return
    case "setUserId":
      VitalClient.setUserId(UUID(uuidString: call.arguments as! String)!)
      result(nil)
      return
    case "askForResources":
      askForResources(resources: call.arguments as! [String], result: result)
      return
    case "syncData":
      syncData(resources: call.arguments as? [String], result: result)
      result(nil)
      return
    case "subscribeToStatus":
      cancellable?.cancel()
      cancellable = VitalHealthKitClient.shared.status.sink { value in
        self.channel.invokeMethod("sendStatus", arguments: "\(value)")
      }
      result(nil)
      return
    case "unsubscribeFromStatus":
      cancellable?.cancel()
      result(nil)
      return
    default:
      break
    }
    result(FlutterError.init(code: "Unsupported method",
                                     message: "Method not supported \(call.method)",
                                     details: nil))
  }

  private func configure(_ arguments: [String], result: @escaping FlutterResult){
    let apiKey = arguments[0]
    let region = arguments[1]
    let environment = arguments[2]
    do {
      VitalClient.configure(
        apiKey: apiKey,
        environment: try resolveEnvironment(region: region, environment: environment)
      )
      VitalHealthKitClient.configure()
      result(nil)
    } catch VitalError.UnsupportedEnvironment(let errorMessage) {
      result(FlutterError.init(code: "UnsupportedEnvironment",
                                     message: errorMessage,
                                     details: nil))
    } catch VitalError.UnsupportedRegion(let errorMessage) {
      result(FlutterError.init(code: "UnsupportedRegion",
                                     message: errorMessage,
                                     details: nil))
    } catch {
      result(FlutterError.init(code: "Unknown error",
                                     message: nil,
                                     details: nil))
    }
  }

  private func askForResources(resources: [String], result: @escaping FlutterResult){
    Task {
        do {
          let outcome = try await VitalHealthKitClient.shared.ask(for: resources.map { try mapResourceToVitalResource($0) })
          switch outcome {
            case .success:
              result(nil)
            case .failure(let message):
              result(FlutterError.init(code: "failure",
                                      message: message,
                                      details: nil))
            case .healthKitNotAvailable:
              result(FlutterError.init(code: "healthKitNotAvailable",
                                      message: "healthKitNotAvailable",
                                      details: nil))
          }
        } catch VitalError.UnsupportedResource(let errorMessage) {
          result(FlutterError.init(code: "errorMessage",
                                     message: errorMessage,
                                     details: nil))
        } catch {
          result(FlutterError.init(code: "Unknown error",
                                        message: nil,
                                        details: nil))
        } 
      }
  }

  private func syncData(resources: [String]?, result: @escaping FlutterResult){
     do {
      if let res = resources {
        try VitalHealthKitClient.shared.syncData(for: res.map { try mapResourceToVitalResource($0) })
      } else {
        VitalHealthKitClient.shared.syncData()
      }
      result(nil)
     } catch VitalError.UnsupportedResource(let errorMessage) {
      result(FlutterError.init(code: "errorMessage",
                                  message: errorMessage,
                                  details: nil))
    } catch {
      result(FlutterError.init(code: "Unknown error",
                                    message: nil,
                                    details: nil))
    } 
  }


  private func resolveEnvironment(region: String, environment: String) throws -> Environment {
    switch region {
    case "eu":
      switch environment {
        case "dev":
          return Environment.dev(.eu)
        case "sandbox":
          return Environment.sandbox(.eu)
        case "production":
          return Environment.production(.eu)
        default:
          throw VitalError.UnsupportedEnvironment("\(environment)")
      }
    case "us":
      switch environment {
        case "dev":
          return Environment.dev(.us)
        case "sandbox":
          return Environment.sandbox(.us)
        case "production":
          return Environment.production(.us)
        default:
          throw VitalError.UnsupportedEnvironment("\(environment)")
      }
    default:
      throw VitalError.UnsupportedRegion("\(region)") 
    }
  }

  private func mapResourceToVitalResource(_ name: String) throws -> VitalResource {
    switch name {
      case "profile":
        return .profile
      case "body":
        return .body
      case "workout":
        return .workout
      case "activity":
        return .activity
      case "sleep":
        return .sleep
      case "glucose":
        return .vitals(.glucose)
      case "bloodPressure":
        return .vitals(.bloodPressure)
      case "hearthRate":
        return .vitals(.hearthRate)
      default:
        throw VitalError.UnsupportedResource(name)
    }
  }
}

enum VitalError: Error {
    case UnsupportedRegion(String)
    case UnsupportedEnvironment(String)
    case UnsupportedResource(String)
}