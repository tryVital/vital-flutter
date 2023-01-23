import 'dart:async';

import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health/vital_health.dart';

class HomeBloc {
  final VitalClient client;
  final HealthServices healthServices;

  final StreamController<List<User>> usersController = StreamController();
  final StreamController<User?> selectedUserController = StreamController();

  User? _selectedUser;

  HomeBloc(this.client, this.healthServices) {
    _connectHealthPlatform();
  }

  Stream<List<User>> getUsers() {
    refresh();
    return usersController.stream;
  }

  void refresh() {
    unawaited(client.userService.getAll().then((response) {
      if (response.body != null) {
        usersController.sink.add(response.body!.users);
      }
    }));
  }

  createUser(String userName) {
    unawaited(
        client.userService.createUser(userName).then((value) => refresh()));
  }

  deleteUser(User user) {
    unawaited(
        client.userService.deleteUser(user.userId!).then((value) => refresh()));
  }

  Future<bool> launchLink(User user) async {
    return client.linkProvider(user, 'strava', 'vitalexample://callback');
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
  }

  void askForHealthResources() {
    healthServices.ask([
      HealthResource.profile,
      HealthResource.body,
      HealthResource.activity,
      HealthResource.heartRate,
      HealthResource.bloodPressure,
      HealthResource.glucose,
      HealthResource.sleep,
      HealthResource.water,
      HealthResource.caffeine,
      HealthResource.mindfulSession
    ], [
      HealthResourceWrite.water,
      HealthResourceWrite.caffeine,
      HealthResourceWrite.mindfulSession
    ]);
  }

  void selectUser(User user) async {
    _selectedUser = user;
    selectedUserController.sink.add(user);

    final userId = _selectedUser?.userId;
    if (userId != null) {
      await healthServices.setUserId(userId);
    }
  }

  void syncHealthPlatform() async {
    final userId = _selectedUser?.userId;
    if (userId != null) {
      await healthServices.setUserId(userId);
      healthServices.syncData();
    }
  }

  Stream<String> get status => healthServices.status.map((event) {
        return event.status.name;
      });

  Stream<User?> get selectedUser => selectedUserController.stream;

  void water(User user) {
    healthServices.writeHealthData(
        HealthResourceWrite.water, DateTime.now(), DateTime.now(), 100);
  }

  void caffeine(User user) {
    healthServices.writeHealthData(
        HealthResourceWrite.caffeine, DateTime.now(), DateTime.now(), 100);
  }

  void mindfulSession(User user) {
    healthServices.writeHealthData(
        HealthResourceWrite.mindfulSession,
        DateTime.now().subtract(const Duration(minutes: 10)),
        DateTime.now(),
        100);
  }
}
