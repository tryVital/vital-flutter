import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_flutter/device.dart';
import 'package:vital_flutter/vital_flutter.dart';
import 'package:vital_flutter_example/device/device_bloc.dart';
import 'package:vital_flutter_example/device/device_screen.dart';
import 'package:vital_flutter_example/devices/devices_bloc.dart';
import 'package:vital_flutter_example/devices/devices_screen.dart';
import 'package:vital_flutter_example/home/home_bloc.dart';
import 'package:vital_flutter_example/home/home_screen.dart';
import 'package:vital_flutter_example/routes.dart';

const apiKey = 'sk_eu_S5LdXTS_CAtdFrkX9OYsiVq_jGHaIXtZyBPbBtPkzhA';
const region = Region.eu;

void main() {
  Fimber.plantTree(DebugTree());

  final vitalClient = VitalClient()
    ..init(
      region: region,
      environment: Environment.sandbox,
      apiKey: apiKey,
    );
  runApp(VitalSampleApp(vitalClient: vitalClient));
}

class VitalSampleApp extends StatelessWidget {
  final VitalClient vitalClient;

  const VitalSampleApp({
    super.key,
    required this.vitalClient,
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
                create: (_) => HomeBloc(vitalClient),
                child: const UsersScreen(),
              ),
          Routes.devices: (_) => ChangeNotifierProvider(
                create: (_) => DevicesBloc(vitalClient),
                child: const DevicesScreen(),
              ),
          Routes.device: (context) => ChangeNotifierProvider(
                create: (_) => DeviceBloc(
                  vitalClient,
                  ModalRoute.of(context)!.settings.arguments as DeviceModel,
                ),
                child: const DeviceScreen(),
              )
        });
  }
}
