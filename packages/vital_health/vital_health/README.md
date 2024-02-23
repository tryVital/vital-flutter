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


2. Follow [Android SDK](https://docs.tryvital.io/wearables/sdks/android) instructions regarding Health Connect
   capabilities setup for your Android app.


3. To use Vital Health client you need to call configure first:

```dart
import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_health/vital_health.dart' as vital_health;

await vital_core.configure(
  apiKey,
  Environment.sandbox,
  Region.us
);

await vital_health.configure(HealthConfig(
    iosConfig: IosHealthConfig(
      backgroundDeliveryEnabled: true,
    ),
    androidConfig: AndroidHealthConfig(
      syncOnAppStart: true,
    ),
));
```

4. Set User ID

```dart
vital_core.setUserId('eba7c0a2-dc01-49f5-a361-...);
```

5. Ask user for permissions to collect/write Health data.

```dart
vital_health.askForPermission(
  [
    HealthResource.profile,
    HealthResource.body,
    ...
  ],
  [
    HealthResourceWrite.water,
    ...
  ]
);
```

6. Sync data

```dart
vital_health.syncData();
```

7. Observe sync status using status stream

```dart
Stream<SyncStatus> status = vital_health.status;
```

8. When your user logs out, you can call `signOut()` to reset the SDK state. This resets both the Vital Health and the Vital Core SDK.
    
```dart
vital_health.signOut();
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
