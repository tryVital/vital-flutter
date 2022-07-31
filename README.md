# vital_flutter

The official Flutter package for Vital API and HealthKit

## Getting Started

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
client.linkProvider(user, 'strava', 'vitalexample://callback');
```

> Note: To return back to the app after successful linking, setup an intent filter in `AndroidManifest.xml` and custom URL scheme in `info.plist`.
> Note 2: Refer to [documentation](https://docs.tryvital.io/wearables/providers/Introduction) for all supported data providers.


### HealthKit

1. Follow [iOS SDK](https://docs.tryvital.io/wearables/sdks/iOS#6-vitalhealthkit) instructions regarding HealthKit capabilities and [background delivery](https://docs.tryvital.io/wearables/sdks/iOS#1-background-delivery) setup for your iOS app.

2. To use HealthKit client you need to call configure first:

```dart
await client.platformServices.configure(
      apiKey: apiKey,
      region: region,
      environment: environment,
    );
```

3. Set User ID

```dart
client.platformServices.setUserId('eba7c0a2-dc01-49f5-a361-...);
```

4. Ask user for permissions to collect HealthKit data.

```dart
client.platformServices.askForResources([
      VitalResource.profile,
      VitalResource.body,
      ...
    ]);
```

5. Sync data

```dart
client.platformServices.syncData();
```

6. Observe sync status using status stream

```dart
Stream<String> status = client.platformServices.status
```

## Documentation

Please refer to the [official Vital](https://docs.tryvital.io/welcome/libraries) docs provide a full reference on using this library.

## License

vital-flutter is available under the AGPLv3 license. See the LICENSE file for more info. VitalDevices is under the `Adept Labs Enterprise Edition (EE) license (the “EE License”)`. Please refer to its license inside its folder.


