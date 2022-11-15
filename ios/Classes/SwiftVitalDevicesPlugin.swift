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
    private var scannedDevices: [ScannedDevice] = []

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
        result(DevicesManager.brands().map({ mapBrandToString($0) }))
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

    private func scanForDevice(_ arguments: [AnyObject], result: @escaping FlutterResult){
        do {
            let deviceModel = DeviceModel(
                id: arguments[0] as! String,
                name: arguments[1] as! String,
                brand: try mapStringToBrand(arguments[2] as! String),
                kind: try mapStringToKind(arguments[3] as! String)
            )

            scannerResultCancellable?.cancel()
            scannerResultCancellable =  deviceManager.search(for:deviceModel)
                .sink {[weak self] value in
                       self?.scannedDevices.append(value)
                       self?.channel.invokeMethod("sendScan", arguments: encode(InternalScannedDevice(id: value.id.uuidString, name: value.name, deviceModel: value.deviceModel)))
                }

            result(nil)
        } catch VitalError.UnsupportedBrand(let errorMessage) {
            result(encode(ErrorResult(code: "UnsupportedBrand", message: errorMessage)))
        } catch VitalError.UnsupportedKind(let errorMessage) {
            result(encode(ErrorResult(code: "UnsupportedKind", message: errorMessage)))
        } catch {
            result(encode(ErrorResult(code: "Unknown error")))
        }
    }

    private func stopScanForDevice(result: @escaping FlutterResult){
        scannerResultCancellable?.cancel()
        result(nil)
    }

    private func pair(_ arguments: [AnyObject], result: @escaping FlutterResult){
        let scannedDeviceId = UUID(uuidString: arguments[0] as! String)!
        let scannedDevice = scannedDevices.first(where: { $0.id == scannedDeviceId })

        guard scannedDevice != nil else {
            result(encode(ErrorResult(code: "DeviceNotFound", message: "Device not found with id \(scannedDeviceId)")))
            return
        }

        pairCancellable?.cancel()
        switch scannedDevice!.deviceModel.kind{
            case .glucoseMeter:
                pairCancellable = deviceManager
                    .glucoseMeter(for: scannedDevice!)
                    .pair(device: scannedDevice!)
                    .sink(receiveCompletion: {[weak self] value in
                        guard self?.flutterRunning ?? false else {
                            return
                        }

                        self?.handlePairCompletion(value: value, channel: self?.channel)
                    },
                    receiveValue:{[weak self] value in
                        guard self?.flutterRunning ?? false else {
                            return
                        }

                        self?.handlePairValue(channel: self?.channel)
                    })
            case .bloodPressure:
                pairCancellable = deviceManager
                    .bloodPressureReader(for: scannedDevice!)
                    .pair(device: scannedDevice!)
                    .sink(receiveCompletion: {[weak self] value in
                        guard self?.flutterRunning ?? false else {
                            return
                        }

                        self?.handlePairCompletion(value: value, channel: self?.channel)
                    },
                    receiveValue:{[weak self] value in
                        guard self?.flutterRunning ?? false else {
                            return
                        }

                        self?.handlePairValue(channel: self?.channel)
                    })
        }
        result(nil)
    }

    private func handlePairCompletion(value: Subscribers.Completion<any Error>, channel: FlutterMethodChannel?){
        switch value {
            case .failure(let error):  channel?.invokeMethod("sendPair", arguments: ErrorResult(code: "PairError", message: error.localizedDescription))
            case .finished:  channel?.invokeMethod("sendPair", arguments: encode(true))
        }
    }

    private func handlePairValue(channel: FlutterMethodChannel?) {
        channel?.invokeMethod("sendPair", arguments: encode(true))
    }

    private func startReadingGlucoseMeter(_ arguments: [AnyObject], result: @escaping FlutterResult){
        let scannedDeviceId = UUID(uuidString: arguments[0] as! String)!
        let scannedDevice = scannedDevices.first(where: { $0.id == scannedDeviceId })

        guard scannedDevice != nil else {
            result(encode(ErrorResult(code: "DeviceNotFound", message: "Device not found with id \(scannedDeviceId)")))
            return
        }

        glucoseMeterCancellable?.cancel()
        glucoseMeterCancellable =  deviceManager.glucoseMeter(for :scannedDevice!)
            .read(device: scannedDevice!)
            .sink (receiveCompletion: {[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }

                self?.channel.invokeMethod("sendGlucoseMeterReading", arguments: "error reading data from device \(value)")
            }, receiveValue:{[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }

                self?.channel.invokeMethod("sendGlucoseMeterReading", arguments: encode(value))
            })
        result(nil)
    }

    private func startReadingBloodPressure(_ arguments: [AnyObject], result: @escaping FlutterResult){
        let scannedDeviceId = UUID(uuidString: arguments[0] as! String)!
        let scannedDevice = scannedDevices.first(where: { $0.id == scannedDeviceId })

        guard scannedDevice != nil else {
            result(encode(ErrorResult(code: "DeviceNotFound", message: "Device not found with id \(scannedDeviceId)")))
            return
        }

        bloodPressureCancellable?.cancel()
        bloodPressureCancellable = deviceManager.bloodPressureReader(for :scannedDevice!)
            .read(device: scannedDevice!)
            .sink (receiveCompletion: {[weak self] value in
                guard self?.flutterRunning ?? false else {
                    return
                }

                self?.channel.invokeMethod("sendBloodPressureReading", arguments: "error reading data from device \(value)")
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
        scannedDevices = []
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

private func mapBrandToString(_ brand: Brand) -> String {
    switch brand {
    case .omron: return "omron"
    case .accuChek: return "accuChek"
    case .contour: return "contour"
    case .beurer: return "beurer"
    case .libre: return "libre"
    }
}

private func encode(_ encodable: Encodable) -> String? {
  let json: String?
  let jsonEncoder = JSONEncoder()

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
}
