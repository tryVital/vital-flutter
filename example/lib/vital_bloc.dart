import 'dart:async';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/vital_flutter.dart';

class VitalBloc {
  final client = VitalClient();

  final StreamController<List<User>> usersController = StreamController();
  final StreamController<User?> selectedUserController = StreamController();

  final String apiKey;
  final Region region;
  final Environment environment;
  User? _selectedUser;

  VitalBloc(this.apiKey, this.region, this.environment) {
    client.init(region: region, environment: environment, apiKey: apiKey);
    _connectHealthPlatform();
  }

  Stream<List<User>> getUsers() {
    refresh();
    return usersController.stream;
  }

  void refresh() {
    unawaited(client.userService.getAll().then((response) {
      if (response.body != null) {
        usersController.sink.add(response.body!);
      }
    }));
  }

  createUser(String userName) {
    unawaited(client.userService.createUser(userName).then((value) => refresh()));
  }

  deleteUser(User user) {
    unawaited(client.userService.deleteUser(user.userId!).then((value) => refresh()));
  }

  Future<bool> launchLink(User user) async {
    return client.linkProvider(user, 'strava', 'vitalexample://callback');
  }

  void _connectHealthPlatform() async {
    await client.healthkitServices.configure();
  }

  void askForHealthResources() {
    client.healthkitServices.askForResources([
      HealthkitResource.profile,
      HealthkitResource.body,
      HealthkitResource.activity,
      HealthkitResource.heartRate,
      HealthkitResource.bloodPressure,
      HealthkitResource.glucose
    ]);
  }

  void selectUser(User user) {
    _selectedUser = user;
    selectedUserController.sink.add(user);
  }

  void syncHealthPlatform() async {
    final userId = _selectedUser?.userId;
    if (userId != null) {
      await client.healthkitServices.setUserId(userId);
      client.healthkitServices.syncData();
    }
  }

  Stream<String> get status => client.healthkitServices.status.map((event) {
        return event.status.name;
      });

  Stream<User?> get selectedUser => selectedUserController.stream;
}
