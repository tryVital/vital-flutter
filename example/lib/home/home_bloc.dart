import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vital_core/provider.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_health/vital_health.dart' as vital_health;

class UserListError {
  final int statusCode;
  final String message;

  UserListError(this.statusCode, this.message);
}

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
    unawaited(client.controlPlaneService.getAll().then((response) {
      if (response.isSuccessful) {
        if (response.body != null) {
          usersController.sink.add(response.body!.users);
        }
      } else {
        usersController.sink.addError(
            UserListError(response.statusCode, response.error.toString()));
      }
    }));
  }

  createUser(String userName) {
    unawaited(client.controlPlaneService
        .createUser(userName)
        .then((value) => refresh()));
  }

  deleteUser(User user) {
    unawaited(client.controlPlaneService
        .deleteUser(user.userId)
        .then((value) => refresh()));
  }

  Future<bool> launchLink(User user, ProviderSlug provider) async {
    return client.linkProvider(
        user, provider.toString(), 'vitalexample://callback');
  }

  openSyncProgressView() {
    unawaited(vital_health.openSyncProgressView());
  }
}
