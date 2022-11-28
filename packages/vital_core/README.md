# vital_core

[![pub package](https://img.shields.io/pub/v/vital_client.svg)](https://pub.dev/packages/vital_core)

A Flutter plugin for Vital Core.

## Getting Started

The Vital SDK is split into three main components: `vital_core`, `vital_health` and `vital_devices`.

- [vital_core][1] holds common
  components to both `vital_health` and `vital_devices`. Among other things, it has the network layer that allows us to
  send data from a device to a server.
- [vital_health][2] is an abstraction over HealthKit an Health Connect(coming soon)
- [vital_devices][3] is an abstraction over a set of Bluetooth devices.

## Usage

Initialise client with region, environment and api key

```dart
final client = VitalClient()
  ..init(region: Region.eu, environment: Environment.sandbox, apiKey: 'sk_eu_...');
```

Query users:

```dart
final Response<List<User>> usersResponse = client.userService.getAll();
```

Link data provider:

```dart
client.linkProvider(user, 'strava','vitalexample: //callback');
```

> Note: To return back to the app after successful linking, setup an intent filter in `AndroidManifest.xml` and custom
> URL scheme in `info.plist`.
> Note 2: Refer to [documentation](https://docs.tryvital.io/wearables/providers/Introduction) for all supported data
> providers.

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

