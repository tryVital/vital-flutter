import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vital_devices/device.dart';
import 'package:vital_flutter_example/devices/devices_bloc.dart';
import 'package:vital_flutter_example/routes.dart';

const imageSize = 56.0;

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DevicesBloc bloc = context.watch<DevicesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Supported devices'),
      ),
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Text(
                "Blood pressure devices",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Column(
                children: bloc.bloodPressureDevices.map((device) {
                  return ListTile(
                    leading: Image.network(
                      deviceImageUrl(device),
                      height: imageSize,
                      width: imageSize,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: imageSize),
                    ),
                    title: Text(device.name),
                    subtitle: Text(device.brand.name),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () => Navigator.of(context).pushNamed(
                      Routes.device,
                      arguments: device,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Text(
                "Glucose meter devices",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Column(
                children: bloc.glucoseMeterDevices
                    .map((device) => ListTile(
                          leading: Image.network(deviceImageUrl(device),
                              height: imageSize,
                              width: imageSize,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, size: imageSize)),
                          title: Text(device.name),
                          subtitle: Text(device.brand.name),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_outlined),
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.device,
                            arguments: device,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

String deviceImageUrl(DeviceModel device) {
  switch (device.id) {
    case "omron_m4":
      return "https://storage.googleapis.com/vital-assets/omron_m4.jpeg";
    case "omron_m7":
      return "https://storage.googleapis.com/vital-assets/omron_m7.jpeg";
    case "accuchek_guide":
      return "https://storage.googleapis.com/vital-assets/accu_check_guide.png";
    case "accuchek_guide_active":
      return "https://storage.googleapis.com/vital-assets/accu_check_active.png";
    case "accuchek_guide_me":
      return "https://storage.googleapis.com/vital-assets/accu_chek_guide_me.jpeg";
    case "contour_next_one":
      return "https://storage.googleapis.com/vital-assets/beurer.png";
    case "beurer":
      return "https://storage.googleapis.com/vital-assets/beurer.png";
    default:
      return "http://placekitten.com/200/200";
  }
}
