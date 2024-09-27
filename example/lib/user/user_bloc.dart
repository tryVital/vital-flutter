import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:vital_core/services/data/control_plane.dart';
import 'package:vital_core/services/data/link.dart';
import 'package:vital_core/services/data/user.dart';
import 'package:vital_core/vital_core.dart' as vital_core;
import 'package:vital_core/vital_core.dart';
import 'package:vital_flutter_example/secrets.dart';
import 'package:vital_health/vital_health.dart' as vital_health;
import 'package:chopper/chopper.dart';

enum SDKAuthMode { signInTokenDemo, apiKey }

class UserBloc extends ChangeNotifier {
  final User user;
  final vital_core.VitalClient vitalClient;
  StreamSubscription? subscription;

  bool isCurrentSDKUser = false;
  bool isSDKConfigured = false;
  bool isHealthDataAvailable = false;
  bool initialSyncDone = false;

  bool pauseSync = false;
  bool isBackgroundSyncEnabled = false;

  bool hasDisposed = false;
  bool showBackgroundSyncSwitch = false;

  Stream<String> get healthSyncStatus =>
      vital_health.syncStatus.map((event) => event.status.name);

  UserBloc(this.user, this.vitalClient) {
    subscription = vital_core.clientStatusStream.listen((status) {
      syncSDKStatus(status);
    });
    vital_core.clientStatus().then((status) => syncSDKStatus(status));
    showBackgroundSyncSwitch =
        !vital_health.canEnableBackgroundSyncNoninteractively;
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription!.cancel();
    }

    hasDisposed = true;
    super.dispose();
  }

  void syncSDKStatus(Set<vital_core.ClientStatus> status) async {
    isCurrentSDKUser = await vital_core.currentUserId() == user.userId;
    isSDKConfigured = status.contains(vital_core.ClientStatus.configured);
    isHealthDataAvailable = await vital_health.isAvailable();
    isBackgroundSyncEnabled = await vital_health.isBackgroundSyncEnabled;
    pauseSync = await vital_health.pauseSynchronization;
    initialSyncDone = true;

    if (!hasDisposed) {
      notifyListeners();
    }
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
        await vital_core.setUserId(user.userId);
        break;

      case SDKAuthMode.signInTokenDemo:
        // IMPORTANT:
        //
        // Calling `POST /v2/user/{id}/sign_in_token` from example app is ONLY
        // for illustration purpose. In practice, this should be called by
        // your backend service on behalf of your consumer apps, so that your
        // Vital API Key is kept strictly as a server-side secret.
        //
        CreateSignInTokenResponse response = await vitalClient
            .controlPlaneService
            .createSignInToken(user.userId)
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
    await vital_core.signOut();
  }

  void createLinkToken() async {
    VitalClient client =
        VitalClient.forSignedInUser(environment: environment, region: region);
    String userId = (await vital_core.currentUserId())!;

    Response<CreateLinkResponse> resp = await client.linkService.createLink(
        userId: userId, provider: "fitbit", redirectUrl: "x-vital-app://");

    if (resp.error != null) {
      Fimber.i("Create Link Token Failed: ${resp.error}");
    } else {
      Fimber.i("Create Link Token OK: ${resp.body?.linkToken}");
    }
  }

  void createLinkWidgetUrl() async {
    VitalClient client =
        VitalClient.forSignedInUser(environment: environment, region: region);

    try {
      Uri widgetUrl = await client.linkWidgetUrl(redirectUrl: "x-vital-app://");
      Fimber.i("Link Widget URL: $widgetUrl");
    } catch (err) {
      Fimber.e("Get Link Widget URL Failed: $err");
    }
  }

  void getUserConnections() async {
    try {
      List<vital_core.UserConnection> connections =
          await vital_core.userConnections();
      Fimber.i("User Connections: found ${connections.length}");
      for (var conn in connections) {
        Fimber.i("$conn");
        Fimber.i("${conn.resourceAvailability}");
      }
    } catch (err) {
      Fimber.e("Get User Connections Failed: $err");
    }
  }

  void askForHealthResources() async {
    vital_health.PermissionOutcome outcome =
        await vital_health.askForPermission([
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

    Fimber.i("Ask Outcome: $outcome");
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
    vital_health.ProcessedData? result = await vital_health.read(healthResource,
        DateTime.now().subtract(const Duration(days: 10)), DateTime.now());

    Fimber.i("Read $healthResource: $result");
  }

  void setBackgroundSyncEnabled(bool enabled) {
    // Optimistic update
    isBackgroundSyncEnabled = enabled;
    notifyListeners();

    if (enabled) {
      vital_health.enableBackgroundSync().then((success) {
        isBackgroundSyncEnabled = success;
        if (!hasDisposed) {
          notifyListeners();
        }
      });
    } else {
      vital_health.disableBackgroundSync().then((_) {
        isBackgroundSyncEnabled = false;
        if (!hasDisposed) {
          notifyListeners();
        }
      });
    }
  }

  void setPauseSync(bool paused) {
    vital_health.setPauseSynchronization(paused);
    pauseSync = paused;
    notifyListeners();
  }
}
