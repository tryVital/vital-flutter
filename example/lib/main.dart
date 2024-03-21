import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_devices/vital_devices.dart';
import 'package:vital_flutter_example/device/device_bloc.dart';
import 'package:vital_flutter_example/device/device_screen.dart';
import 'package:vital_flutter_example/devices/devices_bloc.dart';
import 'package:vital_flutter_example/devices/devices_screen.dart';
import 'package:vital_flutter_example/home/home_bloc.dart';
import 'package:vital_flutter_example/home/home_screen.dart';
import 'package:vital_flutter_example/routes.dart';
import 'package:vital_flutter_example/secrets.dart';
import 'package:vital_flutter_example/user/user_bloc.dart';
import 'package:vital_flutter_example/user/user_screen.dart';

import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_health/vital_health.dart' as vital_health;

StreamSubscription? clientStatusSubscription;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree());

  final vitalClient = vital_core.VitalClient()
    ..init(
      region: region,
      environment: environment,
      apiKey: apiKey,
    );

  final DeviceManager deviceManager = DeviceManager();

  vital_health.setSyncNotificationContent(vital_health.SyncNotificationContent(
      "Example Sync",
      "Syncing your data",
      "Example Sync",
      "Notifies when Example is syncing your data"));

  // Print initial SDK status, and then listen for any change.
  vital_core.clientStatus().then(
      (status) => Fimber.i("vital_core launch status: ${status.join(", ")}"));
  vital_core
      .currentUserId()
      .then((userId) => Fimber.i("vital_core launch userId: $userId"));
  clientStatusSubscription =
      vital_core.clientStatusStream.listen((status) async {
    Fimber.i("vital_core status changed: ${status.join(", ")}");

    //
    // Updating user fallback time zone at app launch:
    //
    if (status.contains(vital_core.ClientStatus.signedIn)) {
      final client = vital_core.VitalClient.forSignedInUser(
          region: region, environment: environment);
      final userId = await vital_core.currentUserId();
      if (userId == null) {
        return;
      }

      // IANA timezone ID
      final timeZone = await vital_core.systemTimeZoneName();
      Fimber.i("will patch user fallback time zone: $timeZone");
      await client.userService.patchUser(userId, fallbackTimeZone: timeZone);

      final updatedUser = await client.userService.getUser(userId);
      Fimber.i(
          "updated user fallback time zone: ${updatedUser.body?.fallbackTimeZone?.id} at ${updatedUser.body?.fallbackTimeZone?.updatedAt}");
    }
  });

  runApp(
      VitalSampleApp(vitalClient: vitalClient, deviceManager: deviceManager));
}

class VitalSampleApp extends StatelessWidget {
  final vital_core.VitalClient vitalClient;

  final DeviceManager deviceManager;

  const VitalSampleApp({
    super.key,
    required this.vitalClient,
    required this.deviceManager,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade300),
        ),
        initialRoute: Routes.home,
        routes: {
          Routes.home: (_) => ChangeNotifierProvider(
                create: (_) => HomeBloc(
                  vitalClient,
                ),
                child: const UsersScreen(),
              ),
          Routes.devices: (_) => ChangeNotifierProvider(
                create: (_) => DevicesBloc(deviceManager),
                child: const DevicesScreen(),
              ),
          Routes.device: (context) => ChangeNotifierProvider(
                create: (_) => DeviceBloc(
                  context,
                  deviceManager,
                  ModalRoute.of(context)!.settings.arguments as DeviceModel,
                ),
                child: const DeviceScreen(),
              ),
          Routes.user: (context) => ChangeNotifierProvider(
                create: (_) => UserBloc(
                  ModalRoute.of(context)!.settings.arguments as User,
                  vitalClient,
                ),
                child: const UserScreen(),
              ),
        });
  }
}
