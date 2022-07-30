import Flutter
import UIKit
import Combine
import VitalCore
import VitalHealthKit

public class SwiftVitalFlutterPlugin: NSObject, FlutterPlugin {

  private let jsonEncoder = JSONEncoder()
  private var cancellable: Cancellable? = nil
  private let channel: FlutterMethodChannel
 
  init(_ channel: FlutterMethodChannel){
    self.channel = channel;
    jsonEncoder.outputFormatting = .withoutEscapingSlashes
    jsonEncoder.dateEncodingStrategy = .iso8601
  }
   
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
      subscribeToStatus()
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
      result(encode(ErrorResult(code: "UnsupportedEnvironment", message: errorMessage)))
    } catch VitalError.UnsupportedRegion(let errorMessage) {
      result(encode(ErrorResult(code: "UnsupportedRegion", message: errorMessage)))
    } catch {
      result(encode(ErrorResult(code: "Unknown error")))
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
              result(encode(ErrorResult(code: "failure", message: message)))
            case .healthKitNotAvailable:
              result(encode(ErrorResult(code: "healthKitNotAvailable", message: "healthKitNotAvailable")))
          }
        } catch VitalError.UnsupportedResource(let errorMessage) {
          result(encode(ErrorResult(code: "UnsupportedResource", message: errorMessage)))
        } catch {
          result(encode(ErrorResult(code: "Unknown error")))
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
      result(encode(ErrorResult(code: "UnsupportedResource", message: errorMessage)))
    } catch {
      result(encode(ErrorResult(code: "Unknown error")))
    } 
  }

  private func subscribeToStatus(){
    cancellable?.cancel()
    cancellable = VitalHealthKitClient.shared.status.sink { value in
      self.channel.invokeMethod("sendStatus", arguments: self.mapStatusToArguments(value))
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

  private func mapStatusToArguments(_ status: VitalHealthKitClient.Status) -> [Any?]{
    switch status {
      case .failedSyncing(let resource, let error):
        return ["failedSyncing", mapVitalResourceToResource(resource), error?.localizedDescription]
      case .successSyncing(let resource, let data):
        return ["successSyncing", mapVitalResourceToResource(resource), encodePostResourceData(data)]
      case .nothingToSync(let resource):
        return ["nothingToSync", mapVitalResourceToResource(resource), nil]
      case .syncing(let resource):
        return ["syncing", mapVitalResourceToResource(resource), nil]
      case .syncingCompleted:
        return ["syncingCompleted", nil, nil]
    }
  }

  private func mapVitalResourceToResource(_ resource: VitalResource) -> String {
    switch resource {
      case .profile:
        return "profile"
      case .body:
        return "body"
      case .workout:
        return "workout"
      case .activity:
        return "activity"
      case .sleep:
        return "sleep"
      case .vitals(let type):
        switch type{
          case .glucose:
            return "glucose"
          case .bloodPressure:
            return "bloodPressure"
          case .hearthRate:
            return "hearthRate"
        }
    }
  }

  private func encodePostResourceData(_ data: PostResourceData) -> [String?]{
    let payload: String? = encode(data.payload)
    return [data.name, payload]
  }

  private func encode(_ encodable: Encodable) -> String? {
    let json: String?
    if let data = try? encode(encodable, encoder: jsonEncoder) {
      json = String(data: data, encoding: .utf8)
    } else {
      json = nil
    }
    return json
  }

  private func encode(_ value: Encodable, encoder: JSONEncoder) throws -> Data? {
    if let data = value as? Data {
        return data
    } else if let string = value as? String {
        return string.data(using: .utf8)
    } else {
        return try encoder.encode(AnyEncodable(value: value))
    }
  }
}

struct AnyEncodable: Encodable {
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

struct ErrorResult: Encodable {
  let code: String
  let message: String?

  init(code: String, message: String? = nil){
    self.code = code
    self.message = message
  }
}

enum VitalError: Error {
    case UnsupportedRegion(String)
    case UnsupportedEnvironment(String)
    case UnsupportedResource(String)
}