import 'dart:async';

import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/vital_flutter.dart';
import 'package:vital_flutter/vital_resource.dart';

class VitalBloc {
  final client = VitalClient();

  final StreamController<List<User>> usersController = StreamController();

  final String apiKey;
  final Region region;
  final Environment environment;

  VitalBloc(this.apiKey, this.region, this.environment) {
    client.init(region: region, environment: environment, apiKey: apiKey);
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

  void connectHealthPlatform() async {
    await client.platformServices.configure(
      apiKey: apiKey,
      region: region,
      environment: environment,
    );
  }

  void setUserId() {
    client.platformServices.setUserId('eba7c0a2-dc01-49f5-a361-5149bd318f43');
  }

  void askForHealthResources() {
    client.platformServices
        .askForResources([VitalResource.profile, VitalResource.body, VitalResource.activity, VitalResource.hearthRate]);
  }

  void syncHealthPlatform() {
    client.platformServices.syncData();
  }

  Stream<String> get status => client.platformServices.status;
}
