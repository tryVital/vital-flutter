import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_devices/vital_devices.dart';
import 'package:vital_flutter_example/device/device_bloc.dart';
import 'package:vital_flutter_example/device/device_screen.dart';
import 'package:vital_flutter_example/devices/devices_bloc.dart';
import 'package:vital_flutter_example/devices/devices_screen.dart';
import 'package:vital_flutter_example/home/home_bloc.dart';
import 'package:vital_flutter_example/home/home_screen.dart';
import 'package:vital_flutter_example/routes.dart';
import 'package:vital_flutter_example/user/user_bloc.dart';
import 'package:vital_flutter_example/user/user_screen.dart';
import 'package:vital_health/vital_health.dart';

const apiKey = 'sk_eu_S5Ld...'; //TODO replace it with your own api key
const region = Region.eu;

void main() {
  Fimber.plantTree(DebugTree());

  final vitalClient = VitalClient()
    ..init(
      region: region,
      environment: Environment.sandbox,
      apiKey: apiKey,
    );

  final DeviceManager deviceManager = DeviceManager();
  final HealthServices healthServices = HealthServices(
    apiKey: apiKey,
    region: region,
    environment: Environment.sandbox,
  );
  runApp(VitalSampleApp(
      vitalClient: vitalClient,
      deviceManager: deviceManager,
      healthServices: healthServices));
}

class VitalSampleApp extends StatelessWidget {
  final VitalClient vitalClient;

  final DeviceManager deviceManager;
  final HealthServices healthServices;

  const VitalSampleApp({
    super.key,
    required this.vitalClient,
    required this.deviceManager,
    required this.healthServices,
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
          Routes.home: (_) => Provider(
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
                  healthServices,
                ),
                child: const UserScreen(),
              ),
        });
  }
}
