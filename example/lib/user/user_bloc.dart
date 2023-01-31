import 'package:flutter/foundation.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_health/vital_health.dart';

class UserBloc extends ChangeNotifier {
  final User user;
  final HealthServices healthServices;

  Stream<String> get status =>
      healthServices.status.map((event) => event.status.name);

  UserBloc(this.user, this.healthServices) {
    _connectHealthPlatform();
  }

  void _connectHealthPlatform() async {
    await healthServices.configureClient();
    await healthServices.configureHealth(
      config: const HealthConfig(
        iosConfig: IosHealthConfig(
          backgroundDeliveryEnabled: true,
        ),
      ),
    );
    await healthServices.setUserId(user.userId!);
  }

  void askForHealthResources() {
    healthServices.ask(
      HealthResource.values,
      HealthResourceWrite.values,
    );
  }

  Future<void> sync() async {
    await healthServices.setUserId(user.userId!);
    healthServices.syncData();
  }

  void water() {
    healthServices.writeHealthData(
        HealthResourceWrite.water, DateTime.now(), DateTime.now(), 100);
  }

  void caffeine() {
    healthServices.writeHealthData(
        HealthResourceWrite.caffeine, DateTime.now(), DateTime.now(), 100);
  }

  void mindfulSession() {
    healthServices.writeHealthData(
        HealthResourceWrite.mindfulSession,
        DateTime.now().subtract(const Duration(minutes: 10)),
        DateTime.now(),
        100);
  }

  Future<void> read(HealthResource healthResource) async {
    final result = await healthServices.read(healthResource,
        DateTime.now().subtract(const Duration(days: 10)), DateTime.now());

    if (kDebugMode) {
      print(result);
    }
  }
}
