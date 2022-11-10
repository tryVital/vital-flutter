import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_flutter/kind.dart';
import 'package:vital_flutter_example/device/device_bloc.dart';
import 'package:vital_flutter_example/devices/devices_screen.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceBloc bloc = context.watch<DeviceBloc>();
    final device = bloc.device;

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
                  style: Theme.of(context).textTheme.caption),
              const Divider(),
              ListTile(
                title: const Text('Permissions granted'),
                trailing: bloc.permissionsGranted == true
                    ? const Text("Done")
                    : const Text("Request"),
                onTap: () => bloc.requestPermissions(),
              ),
              const Divider(),
              ListTile(
                title: const Text('Scan for devices'),
                trailing: bloc.scanning
                    ? const CircularProgressIndicator.adaptive()
                    : const Text("Scan"),
                onTap: bloc.scanning ? null : () => bloc.scan(),
              ),
              if (bloc.scanning || bloc.selectedDevice != null) ...[
                const SizedBox(height: 12),
                Text(
                  "Found devices: ${bloc.scannedDevices.length}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (bloc.scannedDevices.isEmpty)
                  const CircularProgressIndicator.adaptive(),
                ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: bloc.scannedDevices
                      .map((e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.id),
                            trailing: bloc.selectedDevice == null
                                ? const Text("Connect")
                                : bloc.selectedDevice == e
                                    ? const CircularProgressIndicator.adaptive()
                                    : null,
                            onTap: () =>
                                bloc.scanning ? bloc.readData(e) : null,
                          ))
                      .toList(),
                ),
              ],
              showResults(context, bloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget showResults(BuildContext context, DeviceBloc bloc) {
    if (bloc.selectedDevice != null) {
      switch (bloc.selectedDevice!.deviceModel.kind) {
        case DeviceKind.glucoseMeter:
          return Column(
            children: [
              Text(
                "Glucose meter results: ${bloc.glucoseMeterResults.length}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListView(
                shrinkWrap: true,
                primary: false,
                children: bloc.glucoseMeterResults
                    .map((e) => ListTile(
                          title: Text(e.value.toString()),
                          subtitle: Text(e.startDate.toString()),
                        ))
                    .toList(),
              ),
            ],
          );
        case DeviceKind.bloodPressure:
          return Column(
            children: [
              Text(
                "Blood pressure results: ${bloc.bloodPressureMeterResults.length}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListView(
                shrinkWrap: true,
                primary: false,
                children: bloc.bloodPressureMeterResults
                    .map((e) => ListTile(
                          title: Text(
                              "${e.systolic}/${e.diastolic} mmHg  -  (${e.pulse} bpm)"),
                          subtitle: Text(e.diastolic.startDate.toString()),
                        ))
                    .toList(),
              ),
            ],
          );
        default:
          return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
