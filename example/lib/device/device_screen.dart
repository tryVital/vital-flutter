import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_devices/vital_devices.dart';
import 'package:vital_flutter_example/device/device_bloc.dart';
import 'package:vital_flutter_example/devices/devices_screen.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceBloc bloc = context.watch<DeviceBloc>();
    final device = bloc.deviceModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                        const SizedBox(height: 12),
                        Image.network(
                          deviceImageUrl(device),
                          height: 72,
                          width: 72,
                        ),
                        Text(device.name,
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(device.brand.name,
                            style: Theme.of(context).textTheme.bodySmall),
                        const Divider(),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Expanded(
                                  child: Text(bloc.scanSubscription != null
                                      ? "BLE Scan: Active"
                                      : "BLE Scan: Idle")),
                              const Spacer(),
                              Expanded(
                                  child: OutlinedButton(
                                onPressed: () {
                                  if (bloc.scanSubscription != null) {
                                    bloc.stopScanning(context);
                                  } else {
                                    bloc.scan(context);
                                  }
                                },
                                child: Text(bloc.scanSubscription != null
                                    ? 'Stop'
                                    : 'Start'),
                              ))
                            ])),
                        const Divider(),
                      ] +
                      showDevices(context, bloc, bloc.connectedDevices,
                          "Connected Devices") +
                      showDevices(context, bloc, bloc.scannedDevices,
                          "Scanned Devices") +
                      [showResults(context, bloc)]))),
    );
  }

  List<Widget> showDevices(BuildContext context, DeviceBloc bloc,
      List<ScannedDevice> devices, String title) {
    Iterable<Widget> rows = devices.map((d) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(child: Text(d.name)),
            const Spacer(),
            Expanded(
                child: OutlinedButton(
              onPressed: () {
                bloc.pair(context, d);
              },
              child: const Text('Pair'),
            )),
            Expanded(
                child: OutlinedButton(
              onPressed: () {
                bloc.readData(context, d);
              },
              child: const Text('Read'),
            ))
          ]));
    });

    return <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          )
        ] +
        rows.toList();
  }

  Widget showResults(BuildContext context, DeviceBloc bloc) {
    final textTheme = Theme.of(context).textTheme;
    final unitTextStyle = textTheme.bodyLarge?.copyWith(color: Colors.grey);
    final valueTextStyle = textTheme.titleLarge;
    final timeTextStyle =
        textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold);
    final dateTextStyle = textTheme.bodyLarge;

    List<Widget> widgets = [];

    if (bloc.glucoseMeterResults.isNotEmpty) {
      widgets += [
        Column(
          children: [
            Text(
              "Glucose meter results: ${bloc.glucoseMeterResults.length}",
              style: textTheme.titleMedium,
            ),
            ListView(
              shrinkWrap: true,
              primary: false,
              children: bloc.glucoseMeterResults.map((e) {
                final measurementTime = e.startDate;

                return ListTile(
                  title: RichText(
                      text: TextSpan(
                          text: e.value.toString(),
                          style: valueTextStyle,
                          children: [
                        TextSpan(text: " ${e.unit}", style: unitTextStyle)
                      ])),
                  subtitle: const Divider(),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${measurementTime.hour.twoDigits}:${measurementTime.minute.twoDigits}:${measurementTime.second.twoDigits}",
                          style: timeTextStyle),
                      Text("${measurementTime.month}/${measurementTime.day}",
                          style: dateTextStyle),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ];
    }

    if (bloc.bloodPressureMeterResults.isNotEmpty) {
      widgets += [
        Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "Blood pressure results: ${bloc.bloodPressureMeterResults.length}",
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              primary: false,
              children: bloc.bloodPressureMeterResults.map((e) {
                final measurementTime = e.systolic.startDate;

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: e.systolic.value.toString(),
                              style: valueTextStyle,
                              children: [
                            TextSpan(
                                text: " ${e.systolic.unit}",
                                style: unitTextStyle)
                          ])),
                      RichText(
                          text: TextSpan(
                              text: e.diastolic.value.toString(),
                              style: valueTextStyle,
                              children: [
                            TextSpan(
                                text: " ${e.diastolic.unit}",
                                style: unitTextStyle)
                          ])),
                      RichText(
                          text: TextSpan(
                              text: e.pulse?.value.toString(),
                              style: valueTextStyle,
                              children: [
                            TextSpan(
                                text: " ${e.pulse?.unit}", style: unitTextStyle)
                          ])),
                    ],
                  ),
                  subtitle: const Divider(),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          "${measurementTime.hour.twoDigits}:${measurementTime.minute.twoDigits}:${measurementTime.second.twoDigits}",
                          style: timeTextStyle),
                      Text("${measurementTime.month}/${measurementTime.day}",
                          style: dateTextStyle),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        )
      ];
    }

    return Column(children: widgets);
  }
}

extension on int {
  String get twoDigits => toString().padLeft(2, '0');
}
