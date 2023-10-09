import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_flutter_example/secrets.dart';
import 'package:vital_health/vital_health.dart' as vital_health;

enum SDKAuthMode { signInTokenDemo, apiKey }

class UserBloc extends ChangeNotifier {
  final User user;
  final vital_core.VitalClient vitalClient;
  StreamSubscription? subscription;

  bool isCurrentSDKUser = false;
  bool isSDKConfigured = false;

  Stream<String> get healthSyncStatus =>
      vital_health.syncStatus.map((event) => event.status.name);

  UserBloc(this.user, this.vitalClient) {
    subscription = vital_core.clientStatusStream.listen((status) {
      syncSDKStatus(status);
    });
    vital_core.clientStatus().then((status) => syncSDKStatus(status));
  }

  void syncSDKStatus(Set<vital_core.ClientStatus> status) async {
    isCurrentSDKUser = await vital_core.currentUserId() == user.userId;
    isSDKConfigured = status.contains(vital_core.ClientStatus.configured);

    notifyListeners();
  }

  void configureSDK(SDKAuthMode authMode) async {
    if (isSDKConfigured) {
      return;
    }

    // The following configuration only needs to be done once until your
    // end user signs out.
    //
    // For iOS, remember to call `automaticConfiguration()` in your native
    // app delegate, so that Vital SDK can consistently reload settings during
    // app launch before everything else happens.

    // [1] Configure Vital Core SDK
    switch (authMode) {
      case SDKAuthMode.apiKey:
        await vital_core.configure(apiKey, environment, region);
        await vital_core.setUserId(user.userId!);
        break;

      case SDKAuthMode.signInTokenDemo:
        CreateSignInTokenResponse response = await vitalClient.userService
            .createSignInToken(user.userId!)
            .then((resp) => resp.isSuccessful
                ? resp.body!
                : throw Exception("HTTP error ${resp.statusCode}"));
        await vital_core.signIn(response.signInToken);
        break;
    }

    // [2] Configure Vital Health SDK
    await vital_health.configure(
      config: const vital_health.HealthConfig(
        iosConfig: vital_health.IosHealthConfig(
          backgroundDeliveryEnabled: true,
        ),
      ),
    );
  }

  void resetSDK() async {
    await vital_health.cleanUp();
  }

  void askForHealthResources() {
    vital_health.askForPermission([
      vital_health.HealthResource.profile,
      vital_health.HealthResource.body,
      vital_health.HealthResource.activity,
      vital_health.HealthResource.heartRate,
      vital_health.HealthResource.bloodPressure,
      vital_health.HealthResource.glucose,
      vital_health.HealthResource.sleep,
      vital_health.HealthResource.water,
      vital_health.HealthResource.caffeine,
      vital_health.HealthResource.mindfulSession
    ], [
      vital_health.HealthResourceWrite.water,
      vital_health.HealthResourceWrite.caffeine,
      vital_health.HealthResourceWrite.mindfulSession
    ]);
  }

  Future<void> sync() async {
    vital_health.syncData();
  }

  void water() {
    vital_health.writeHealthData(vital_health.HealthResourceWrite.water,
        DateTime.now(), DateTime.now(), 100);
  }

  void caffeine() {
    vital_health.writeHealthData(vital_health.HealthResourceWrite.caffeine,
        DateTime.now(), DateTime.now(), 100);
  }

  void mindfulSession() {
    vital_health.writeHealthData(
        vital_health.HealthResourceWrite.mindfulSession,
        DateTime.now().subtract(const Duration(minutes: 10)),
        DateTime.now(),
        100);
  }

  Future<void> read(vital_health.HealthResource healthResource) async {
    final result = await vital_health.read(healthResource,
        DateTime.now().subtract(const Duration(days: 10)), DateTime.now());

    if (kDebugMode) {
      print(result);
    }
  }
}
