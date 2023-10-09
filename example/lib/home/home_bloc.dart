import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart' as vital_core;

class HomeBloc extends ChangeNotifier {
  final vital_core.VitalClient client;

  final StreamController<List<User>> usersController = StreamController();

  StreamSubscription? subscription;
  String? currentUserId;

  HomeBloc(this.client) {
    subscription = vital_core.clientStatusStream.listen((status) async {
      syncSDKState();
    });
    syncSDKState();
  }

  void syncSDKState() async {
    currentUserId = await vital_core.currentUserId();
    notifyListeners();
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
}
