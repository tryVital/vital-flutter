import Flutter
import UIKit
import Combine
import CoreBluetooth
import CoreLocation
import CombineCoreBluetooth
import VitalCore
import VitalDevices

public class SwiftVitalDevicesPlugin: NSObject, FlutterPlugin {
    private let channel: FlutterMethodChannel

    private lazy var deviceManager = DevicesManager()

    private var glucoseMeterCancellable: Cancellable? = nil
    private var bloodPressureCancellable: Cancellable? = nil
    private var pairCancellable: Cancellable? = nil

    private var scannerResultCancellable: Cancellable? = nil
    private var knownScannedDevices: [UUID: ScannedDevice] = [:]

    private var flutterRunning = true

    init(_ channel: FlutterMethodChannel){
        self.channel = channel
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vital_devices", binaryMessenger: registrar.messenger())
        let instance = SwiftVitalDevicesPlugin(channel)

        registrar.publish(instance)

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        flutterRunning = false
        cleanUp()
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        flutterRunning = false
        cleanUp()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "brands":
            getBrands(result: result)
            return
        case "devices":
            getDevices(call.arguments as! String, result:result)
            return
        case "getConnectedDevices":
            getConnectedDevices(call.arguments as! [AnyObject], result: result)
        case "startScanForDevice":
            scanForDevice(call.arguments as! [AnyObject], result: result)
            return
        case "stopScanForDevice":
            stopScanForDevice(result: result)
            return
        case "pair":
            pair(call.arguments as! [AnyObject], result: result)
            return
        case "startReadingGlucoseMeter":
            startReadingGlucoseMeter(call.arguments as! [AnyObject], result: result)
            return
        case "startReadingBloodPressure":
            startReadingBloodPressure(call.arguments as! [AnyObject], result: result)
            return
        case "cleanUp":
            cleanUp()
            result(nil)
            return
        default:
            break
        }

        result(FlutterError.init(code: "Unsupported method",
                                 message: "Method not supported \(call.method)",
                                 details: nil))
    }

    private func getBrands(result: @escaping FlutterResult){
        result(DevicesManager.brands().map({ $0.rawValue }))
    }

    private func getDevices(_ deviceBrand: String, result: @escaping FlutterResult) {
        do {
            result(encode(DevicesManager.devices(for: try mapStringToBrand(deviceBrand))))
        } catch VitalError.UnsupportedBrand(let errorMessage) {
            result(encode(ErrorResult(code: "UnsupportedBrand", message: errorMessage)))
        } catch {
            result(encode(ErrorResult(code: "Unknown error")))
        }
    }

  private func parseDeviceModel(from arguments: [AnyObject]) throws -> DeviceModel {
    return DeviceModel(
      id: arguments[0] as! String,
      name: arguments[1] as! String,
      brand: try mapStringToBrand(arguments[2] as! String),
      kind: try mapStringToKind(arguments[3] as! String)
    )
  }

  private func getConnectedDevices(_ arguments: [AnyObject], result: @escaping FlutterResult) {
    do {
      let deviceModel = try parseDeviceModel(from: arguments)
      let devices = deviceManager.connected(deviceModel)

      // Since we cannot pass reference over Dart channel, we have to keep a
      // registry for later API calls to recover the scanned device instance
      // expected by today's native SDK API.
      devices.forEach { self.knownScannedDevices[$0.id] = $0 }

      result(encode(devices.map(InternalScannedDevice.init)))
    } catch let error {
      result(FlutterError(error))
    }
  }

    private func scanForDevice(_ arguments: [AnyObject], result: @escaping FlutterResult){
        do {
            let deviceModel = try parseDeviceModel(from: arguments)

            scannerResultCancellable?.cancel()
            scannerResultCancellable =  deviceManager.search(for:deviceModel)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                  guard let self = self else { return }

                  // Since we cannot pass reference over Dart channel, we have to keep a
                  // registry so that later API calls can recover the scanned device instance
                  // expected by today's native SDK API.
                  self.knownScannedDevices[value.id] = value

                  self.channel.invokeMethod("sendScan", arguments: encode(InternalScannedDevice(value)))
                }

            result(nil)
        } catch let error {
            channel.invokeMethod("sendScan", arguments: encode(FlutterError(error).encodeAsJson()))
        }
    }

    private func stopScanForDevice(result: @escaping FlutterResult){
        scannerResultCancellable?.cancel()
        result(nil)
    }

    private func pair(_ arguments: [AnyObject], result: @escaping FlutterResult){
      let rawScannedDeviceId = arguments[0] as! String

      guard
        let scannedDeviceId = UUID(uuidString: rawScannedDeviceId),
        let device = knownScannedDevices[scannedDeviceId]
      else {
        result(
          FlutterError(
            code: "PairError",
            message: "Unknown device with ID \(rawScannedDeviceId). Consider reporting this issue if the ID has previously been returned by `scanForDevices` or `getConnectedDevices`.",
            details: nil
          )
        )
        return
      }

      pairCancellable?.cancel()
      switch device.deviceModel.kind{
      case .glucoseMeter:
        pairCancellable = deviceManager
          .glucoseMeter(for: device)
          .pair(device: device)
          .receive(on: DispatchQueue.main)
          .sink { [weak self] value in
            guard self?.flutterRunning ?? false else { return }
            switch value {
            case .finished:
              result(true)
            case let .failure(error):
              result(FlutterError(code: "PairError", message: error.localizedDescription, details: nil))
            }
          } receiveValue: { _ in }
      case .bloodPressure:
        pairCancellable = deviceManager
          .bloodPressureReader(for: device)
          .pair(device: device)
          .receive(on: DispatchQueue.main)
          .sink {[weak self] value in
            guard self?.flutterRunning ?? false else { return }
            switch value {
            case .finished:
              result(true)
            case let .failure(error):
              result(FlutterError(code: "PairError", message: error.localizedDescription, details: nil))
            }
          } receiveValue:{ _ in }
      }
    }

    private func startReadingGlucoseMeter(_ arguments: [AnyObject], result: @escaping FlutterResult){
        let rawScannedDeviceId = arguments[0] as! String

        guard
          let scannedDeviceId = UUID(uuidString: rawScannedDeviceId),
          let scannedDevice = knownScannedDevices[scannedDeviceId]
        else {
            result(encode(ErrorResult(code: "DeviceNotFound", message: "Device not found with id \(rawScannedDeviceId)")))
            return
        }
        
        glucoseMeterCancellable?.cancel()
        glucoseMeterCancellable =  deviceManager.glucoseMeter(for: scannedDevice)
            .read(device: scannedDevice)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: {[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }
                
                switch value {
                case .finished:
                    // Since the contract is delivery-once-then-complete, we assume the Dart `sendGlucoseMeterReading`
                    // should have closed the Dart Stream/Future at this point.
                    return
                case .failure(let error):
                    self?.channel.invokeMethod("sendGlucoseMeterReading", arguments: encode(ErrorResult(code: "GlucoseMeterReadingError", message: error.localizedDescription)))
                }
                
            }, receiveValue:{[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }
                
                self?.channel.invokeMethod("sendGlucoseMeterReading", arguments: encode(value))
            })
        result(nil)
    }

    private func startReadingBloodPressure(_ arguments: [AnyObject], result: @escaping FlutterResult) {
        let rawScannedDeviceId = arguments[0] as! String

        guard
          let scannedDeviceId = UUID(uuidString: rawScannedDeviceId),
          let scannedDevice = knownScannedDevices[scannedDeviceId]
        else {
            result(encode(ErrorResult(code: "DeviceNotFound", message: "Device not found with id \(rawScannedDeviceId)")))
            return
        }
        
        bloodPressureCancellable?.cancel()
        bloodPressureCancellable = deviceManager.bloodPressureReader(for: scannedDevice)
            .read(device: scannedDevice)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: {[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }
                
                switch(value.self){
                case .finished:
                    // Since the contract is delivery-once-then-complete, we assume the Dart `sendBloodPressureReading`
                    // should have closed the Stream/Future at this point.
                    return
                case .failure(let error):
                    self?.channel.invokeMethod("sendBloodPressureReading", arguments: encode(ErrorResult(code: "BloodPressureReadingError", message: error.localizedDescription)))
                }
            }, receiveValue:{[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }
                
                self?.channel.invokeMethod("sendBloodPressureReading", arguments: encode(value))
            })
        result(nil)
    }

    private func cleanUp(){
        glucoseMeterCancellable?.cancel()
        bloodPressureCancellable?.cancel()
        scannerResultCancellable?.cancel()
        pairCancellable?.cancel()
        knownScannedDevices = [:]
    }
}

private func mapStringToBrand(_ brandId: String) throws -> Brand  {
    switch brandId {
        case "omron": return Brand.omron
        case "accuChek": return Brand.accuChek
        case "contour": return Brand.contour
        case "beurer": return Brand.beurer
        case "libre": return Brand.libre
        default: throw VitalError.UnsupportedBrand(brandId)
    }
}

private func mapStringToKind(_ kindId: String) throws -> DeviceModel.Kind  {
    switch kindId {
    case "bloodPressure": return DeviceModel.Kind.bloodPressure
    case "glucoseMeter": return DeviceModel.Kind.glucoseMeter
    default: throw VitalError.UnsupportedKind(kindId)
    }
}

private func encode(_ encodable: Encodable) -> String? {
  let json: String?
  let jsonEncoder = JSONEncoder()
  jsonEncoder.dateEncodingStrategy = .iso8601

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

public struct InternalScannedDevice: Equatable, Encodable {
  public let id: String
  public let name: String
  public let deviceModel: DeviceModel

  init(
    id: String,
    name: String,
    deviceModel: DeviceModel
  ) {
    self.id = id
    self.name = name
    self.deviceModel = deviceModel
  }

  init(_ device: ScannedDevice) {
    self.id = device.id.uuidString
    self.name = device.name
    self.deviceModel = device.deviceModel
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
  case UnsupportedDataPushMode(String)
  case UnsupportedProvider(String)
  case UnsupportedBrand(String)
  case UnsupportedKind(String)
}

extension FlutterError {
    convenience init(_ error: Error) {
        switch error {
        case VitalError.UnsupportedBrand(let errorMessage):
            self.init(code: "UnsupportedBrand", message: errorMessage, details: error)
        case VitalError.UnsupportedKind(let errorMessage):
            self.init(code: "UnsupportedKind", message: errorMessage, details: error)
        default:
            self.init(code: "UnknownError", message: nil, details: error)
        }
    }
    
    func encodeAsJson() -> String? {
        encode(ErrorResult(code: code, message: message ?? ""))
    }
}
