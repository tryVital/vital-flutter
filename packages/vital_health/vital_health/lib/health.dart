import 'dart:async';
import 'dart:io';

import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

// NOTE: All methods are exposed as top-level functions, without a "VitalHealth"
// namespace like the Native and React Native SDKs.
//
// > https://dart.dev/effective-dart/design#avoid-defining-a-class-that-contains-only-static-members
// > AVOID defining a class that contains only static members

/// Health Data sync status.
/// Note that this stream does not replay any status already emitted.
Stream<SyncStatus> get syncStatus => VitalHealthPlatform.instance.status;

/// Current Health SDK connection status.
Future<ConnectionStatus> connectionStatus() async {
  return VitalHealthPlatform.instance.getConnectionStatus();
}

/// Health SDK connection status updates.
Stream<ConnectionStatus> connectionStatusDidChange() {
  return VitalHealthPlatform.instance.connectionStatus();
}

/// Android: Whether Health Connect is available on the current device.
/// iOS: Always return `true`.
Future<bool> isAvailable() async {
  return await VitalHealthPlatform.instance.isAvailable();
}

Future<void> configure({
  HealthConfig config = const HealthConfig(),
}) async {
  await VitalHealthPlatform.instance.configureHealth(config: config);
}

/// Setup a HealthKit (iOS) or Health Connect (Android) connection with this device.
///
/// Precondition: configure the SDK with [ConnectionPolicy.explicit].
Future<void> connect() async {
  return VitalHealthPlatform.instance.connect();
}

/// Disconnect the active HealthKit (iOS) or Health Connect (Android) connection.
///
/// Precondition: configure the SDK with [ConnectionPolicy.explicit].
Future<void> disconnect() async {
  return VitalHealthPlatform.instance.disconnect();
}

Future<PermissionOutcome> askForPermission(List<HealthResource> readResources,
    List<HealthResourceWrite> writeResources) async {
  return VitalHealthPlatform.instance.ask(readResources, writeResources);
}

Future<bool> hasAskedForPermission(HealthResource resource) async {
  return VitalHealthPlatform.instance.hasAskedForPermission(resource);
}

Future<Map<HealthResource, PermissionStatus>> permissionStatus(
    List<HealthResource> resource) async {
  return VitalHealthPlatform.instance.permissionStatus(resource);
}

Future<void> syncData({List<HealthResource>? resources}) async {
  await VitalHealthPlatform.instance.syncData(resources: resources);
}

Future<void> writeHealthData(HealthResourceWrite writeResource,
    DateTime startDate, DateTime endDate, double value) async {
  await VitalHealthPlatform.instance
      .writeHealthData(writeResource, startDate, endDate, value);
}

@Deprecated("Local read is being sunset.")
Future<ProcessedData?> read(
    HealthResource resource, DateTime startDate, DateTime endDate) {
  return VitalHealthPlatform.instance.read(resource, startDate, endDate);
}

bool get canEnableBackgroundSyncNoninteractively {
  return !Platform.isAndroid;
}

/// Whether health data sync is paused at the moment.
Future<bool> get pauseSynchronization async {
  return VitalHealthPlatform.instance.getPauseSynchronization();
}

/// [Android ONLY][Experimental API]
/// On iOS, this property always returns `true`. iOS HealthKit Background Delivery is
/// an app-level entitlement, and does not require explicit user consent.
///
/// ## Overview
///
/// Whether Background Sync on Android is enabled at the moment.
Future<bool> get isBackgroundSyncEnabled async {
  if (!Platform.isAndroid) {
    return true;
  }

  return VitalHealthPlatform.instance.isBackgroundSyncEnabled();
}

/// [Android ONLY][Experimental API]
/// On iOS, this method is a no-op returning `true`. iOS HealthKit Background Delivery is an app-level
/// entitlement, and does not require explicit user consent.
///
/// If you intend to pause or unpause synchronization, use `pauseSynchronization`
/// and `setPauseSynchronization(_:)` instead.
///
/// ## Overview
///
/// Enable background sync on Android. This includes requesting permissions from the end user whenever necessary.
///
/// Vital SDK achieves automatic data sync through Android [AlarmManager] exact alarms.
///
/// Refer to the [Vital Health Connect guide for full context and setup instructions](https://docs.tryvital.io/wearables/guides/android_health_connect).
///
/// ## Gist on Exact Alarms
///
/// "Exact Alarm" here refers to the Android Exact Alarm mechanism. The Vital SDK would propose
/// to the Android OS to fire the next data sync with a T+60min wall clock target. The Android OS
/// may fulfill the request exactly as proposed, e.g., when the user happens to be actively using
/// the device. However, it may also choose to defer it arbitrarily, under the influence of
/// power-saving policies like [Doze mode](https://developer.android.com/training/monitoring-device-state/doze-standby#understand_doze).
///
/// On Android 12 (API Level 31) or above, this contract would automatically initiate the OS-required
/// user consent flow for Exact Alarm usage. If the permission has been granted prior, this activity
/// contract shall return synchronously.
///
/// On Android 13 (API Level 33) or above, you have the option to use (with platform policy caveats)
/// the [android.Manifest.permission.USE_EXACT_ALARM] permission instead, which does not require an
/// explicit consent flow. This contract would return synchronously in this scenario.
///
/// Regardless of API Level, your App Manifest must declare [android.Manifest.permission.RECEIVE_BOOT_COMPLETED].
/// Otherwise, background sync stops once the phone encounters a cold reboot or a quick restart.
///
/// @return `true` if the background sync has been enabled successfully. `false` otherwise.
Future<bool> enableBackgroundSync() async {
  if (!Platform.isAndroid) {
    // iOS background delivery does not require user explicit consent.
    // It requires only the app-level HealthKit Bgnd. Delivery entitlement.
    return true;
  }

  return await VitalHealthPlatform.instance.enableBackgroundSync();
}

/// [Android ONLY][Experimental API]
/// On iOS, this method is a no-op. iOS HealthKit Background Delivery is an app-level
/// entitlement, and does not require explicit user consent.
///
/// If you intend to pause or unpause synchronization, use `pauseSynchronization`
/// and `setPauseSynchronization(_:)` instead.
///
/// ## Overview
///
/// Disable background sync on Android.
Future<void> disableBackgroundSync() async {
  if (!Platform.isAndroid) {
    // iOS background delivery does not require user explicit consent.
    // It requires only the app-level HealthKit Bgnd. Delivery entitlement.
    return;
  }

  return await VitalHealthPlatform.instance.disableBackgroundSync();
}

/// [Android ONLY][Experimental API]
/// On iOS, this method is a no-op. iOS does not require apps to show a user-visible
/// notification when performing extended work in background.
///
/// ## Overview
/// Set the text content related to the Sync Notification. The OS has full discretion to present
/// this notification to the user, when any data sync work in background is taking longer than expected.
///
/// Refer to the [Vital Health Connect guide for full context and setup instructions](https://docs.tryvital.io/wearables/guides/android_health_connect).
Future<void> setSyncNotificationContent(SyncNotificationContent content) async {
  if (!Platform.isAndroid) {
    // iOS background delivery does not require user explicit consent.
    // It requires only the app-level HealthKit Bgnd. Delivery entitlement.
    return;
  }

  return await VitalHealthPlatform.instance.setSyncNotificationContent(content);
}

/// Pause or unpause health data sync.
Future<void> setPauseSynchronization(bool paused) async {
  return await VitalHealthPlatform.instance.setPauseSynchronization(paused);
}

Future<void> openSyncProgressView() async {
  if (Platform.isAndroid) {
    return;
  }

  return await VitalHealthPlatform.instance.openSyncProgressView();
}
