# vital_devices

[![pub package](https://img.shields.io/pub/v/vital_devices.svg)](https://pub.dev/packages/vital_devices)

## Introduction

The Vital SDK is split into three main components: `vital_core`, `vital_health` and `vital_devices`.

- [vital_core][1] holds common
  components to both `vital_health` and `vital_devices`. Among other things, it has the network layer that allows us to
  send data from a device to a server.
- [vital_health][2] is an abstraction over HealthKit an Health Connect(coming soon)
- [vital_devices][3] is an abstraction over a set of Bluetooth devices.

## Getting Started

### iOS

Add the following to your `Info.plist` file:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Our app uses bluetooth to find, connect and transfer data between different devices</string>
```

You will have to request the bluetooth permission in your app before using the SDK.

### Android

Add the following to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>

<!-- Request legacy Bluetooth permissions on older devices. -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" android:maxSdkVersion="30"/>
```

You will have to request the appropriate permissions at in your app before you can call the Vital Devices SDK.

## Usage

First you have to scan for one of the supported devices. You can find the list of supported devices by
calling `DeviceManager().devices`.

```dart
vitalDevices.scanForDevices(deviceModel).listen((device) {
  // now you have the device you were looking for
});
```

Depending on the type of device you are connecting to, you will have to call different methods to connect to it.

### Blood pressure monitor

```dart
vitalDevices.readBloodPressureData(scannedDevice).listen((bloodPressureSamples) {
  // you will receive a list of blood pressure samples
});
```

### Glucose meter

```dart
vitalDevices.readGlucoseMeterData(scannedDevice).listen((glucoseSamples) {
  // you will receive a list of glucose samples
});
```

After you have received samples depending on the type of device you might need to star scanning again to receive the
next set of samples.

## Documentation

For more example usage run the sample app with your API key and Region set in `main.dart`.
Please refer to the [official Vital](https://docs.tryvital.io/welcome/libraries) docs provide a full reference on using
this library.

## License

vital-flutter is available under the AGPLv3 license. See the LICENSE file for more info. VitalDevices is under
the `Adept Labs Enterprise Edition (EE) license (the “EE License”)`. Please refer to its license inside its folder.

[1]: https://pub.dev/packages/vital_core

[2]: https://pub.dev/packages/vital_health

[3]: https://pub.dev/packages/vital_devices
