import 'dart:async';

import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/vital_flutter.dart';

class VitalBloc {
  final client = VitalClient();

  final StreamController<List<User>> usersController = StreamController();

  final String apiKey;
  final Region region;

  VitalBloc(this.apiKey, this.region) {
    client.init(region: region, environment: Environment.sandbox, apiKey: apiKey);
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
}
