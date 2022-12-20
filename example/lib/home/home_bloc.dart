import 'dart:async';

import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health/vital_health.dart';

class HomeBloc {
  final VitalClient client;
  final HealthkitServices healthkitServices;

  final StreamController<List<User>> usersController = StreamController();
  final StreamController<User?> selectedUserController = StreamController();

  User? _selectedUser;

  HomeBloc(this.client, this.healthkitServices) {
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
    await healthkitServices.configureClient();
    await healthkitServices.configureHealthkit(backgroundDeliveryEnabled: true);
  }

  void askForHealthResources() {
    healthkitServices.askForResources([
      HealthkitResource.profile,
      HealthkitResource.body,
      HealthkitResource.activity,
      HealthkitResource.heartRate,
      HealthkitResource.bloodPressure,
      HealthkitResource.glucose,
      HealthkitResource.sleep
    ]);
  }

  Future<bool> hasPermissionForSleep() async {
    return healthkitServices.hasAskedForPermission(HealthkitResource.sleep);
  }

  void selectUser(User user) async {
    _selectedUser = user;
    selectedUserController.sink.add(user);

    final userId = _selectedUser?.userId;
    if (userId != null) {
      await healthkitServices.setUserId("71639293-968e-4aa6-a41a-a5c7548f47e5");
    }
  }

  void syncHealthPlatform() async {
    final userId = _selectedUser?.userId;
    if (userId != null) {
      await healthkitServices.setUserId("71639293-968e-4aa6-a41a-a5c7548f47e5");
      healthkitServices.syncData();
    }
  }

  Stream<String> get status => healthkitServices.status.map((event) {
        return event.status.name;
      });

  Stream<User?> get selectedUser => selectedUserController.stream;
}
