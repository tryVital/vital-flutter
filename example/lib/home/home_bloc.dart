import 'dart:async';

import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart';

class HomeBloc {
  final VitalClient client;

  final StreamController<List<User>> usersController = StreamController();

  HomeBloc(this.client);

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
}
