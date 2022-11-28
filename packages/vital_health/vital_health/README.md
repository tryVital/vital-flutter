# vital_health

[![pub package](https://img.shields.io/pub/v/vital_health.svg)](https://pub.dev/packages/vital_health)

## Introduction

The Vital SDK is split into three main components: `vital_core`, `vital_health` and `vital_devices`.

- [vital_core][1] holds common
  components to both `vital_health` and `vital_devices`. Among other things, it has the network layer that allows us to
  send data from a device to a server.
- [vital_health][2] is an abstraction over HealthKit an Health Connect(coming soon)
- [vital_devices][3] is an abstraction over a set of Bluetooth devices.

## Getting Started

1. Follow [iOS SDK](https://docs.tryvital.io/wearables/sdks/iOS#6-vitalhealthkit) instructions regarding HealthKit
   capabilities and [background delivery](https://docs.tryvital.io/wearables/sdks/iOS#1-background-delivery) setup for
   your iOS app.

2. To use HealthKit client you need to call configure first:

```dart
await client.healthkitServices.configureClient();
await client.healthkitServices.configureHealthkit(backgroundDeliveryEnabled: true);
```

3. Set User ID

```dart
client.healthkitServices.setUserId('eba7c0a2-dc01-49f5-a361-...);
```

4. Ask user for permissions to collect HealthKit data.

```dart
client.healthkitServices.askForResources(
  [
    HealthkitResource.profile,
    HealthkitResource.body,
    ...
  ]
);
```

5. Sync data

```dart
client.healthkitServices.syncData();
```

6. Observe sync status using status stream

```dart
Stream<SyncStatus> status = client.healthkitServices.status
```

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
