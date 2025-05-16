import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_core/exceptions.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_connect');

class VitalHealthAndroid extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instanceFactory = () => VitalHealthAndroid();
  }

  final _statusStream = StreamController<SyncStatus>();
  late final _statusStreamBroadcast = _statusStream.stream.asBroadcastStream();

  VitalHealthAndroid() : super() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "status":
          {
            _statusStream
                .add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          }
      }
    });
  }

  @override
  Future<bool> isAvailable() async {
    return await _channel.invokeMethod('isAvailable');
  }

  @override
  Future<void> configureHealth({required HealthConfig config}) async {
    Fimber.d('Health Connect configureHealthConnect');
    try {
      await _channel.invokeMethod('configureHealthConnect', <String, dynamic>{
        "logsEnabled": config.logsEnabled,
        "numberOfDaysToBackFill": config.numberOfDaysToBackFill,
        "syncOnAppStart": config.androidConfig.syncOnAppStart
      });
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    try {
      final outcome =
          await _channel.invokeMethod('askForResources', [
        readResources.map((e) => e.name).toList(),
        writeResources.map((e) => e.name).toList(),
      ]);

      if (outcome == null) {
        return PermissionOutcome.success();
      } else {
        final error = jsonDecode(outcome);
        final code = error['code'];
        final message = error['message'];
        if (code == 'healthKitNotAvailable') {
          return PermissionOutcome.healthKitNotAvailable(message);
        } else if (code == 'UnsupportedResource') {
          return PermissionOutcome.failure('Unsupported Resource: $message');
        } else {
          return PermissionOutcome.failure('Unknown error');
        }
      }
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> syncData({List<HealthResource>? resources}) async {
    try {
      await _channel.invokeMethod('syncData', <String, dynamic>{
        "resources": resources?.map((e) => e.name).toList(),
      });
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<bool> hasAskedForPermission(HealthResource resource) async {
    try {
      return await _channel.invokeMethod('hasAskedForPermission', resource.name) as bool;
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<Map<HealthResource, PermissionStatus>> permissionStatus(List<HealthResource> resources) async {
    try {
      final result =
        await _channel.invokeMethod('permissionStatus', resources.map((r) => r.name).toList());

      Fimber.i(result);

      Map<String, dynamic> resultMap = jsonDecode(result);
      return resultMap.map((key, value) => MapEntry(HealthResource.values.byName(key), PermissionStatus.values.byName(value as String)));
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    try {
      await _channel.invokeMethod('writeHealthData', <String, dynamic>{
        "resource": writeResource.name,
        "startDate": startDate.millisecondsSinceEpoch,
        "endDate": endDate.millisecondsSinceEpoch,
        "value": value,
      });
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<ProcessedData> read(
      HealthResource resource, DateTime startDate, DateTime endDate) async {
    try {
      if (resource == HealthResource.caffeine ||
          resource == HealthResource.mindfulSession) {
        throw UnsupportedResourceException(
            "Resource $resource is not supported on Android");
      }

      final result = await _channel.invokeMethod('read', <String, dynamic>{
        "resource": resource.name,
        "startDate": startDate.millisecondsSinceEpoch,
        "endDate": endDate.millisecondsSinceEpoch,
      });

      return _mapJsonToProcessedData(resource, jsonDecode(result));
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<bool> getPauseSynchronization() {
    return _channel
        .invokeMethod<bool>('getPauseSynchronization')
        .then((result) => result!);
  }

  @override
  Future<void> setPauseSynchronization(bool paused) {
    return _channel.invokeMethod('setPauseSynchronization', paused);
  }

  @override
  Future<bool> isBackgroundSyncEnabled() {
    return _channel
        .invokeMethod<bool>('isBackgroundSyncEnabled')
        .then((result) => result!);
  }

  @override
  Future<bool> enableBackgroundSync() {
    return _channel
        .invokeMethod<bool>('enableBackgroundSync')
        .then((result) => result!);
  }

  @override
  Future<void> disableBackgroundSync() {
    return _channel.invokeMethod('disableBackgroundSync');
  }

  @override
  Future<void> setSyncNotificationContent(SyncNotificationContent content) {
    final encodedContent = json.encode(content.toMap());
    return _channel.invokeMethod('setSyncNotificationContent', encodedContent);
  }

  @override
  Stream<SyncStatus> get status => _statusStreamBroadcast;
}

ProcessedData _mapJsonToProcessedData(
    HealthResource resource, Map<String, dynamic> json) {
  switch (resource) {
    case HealthResource.profile:
      return ProfileProcessedData(
        biologicalSex: json['biologicalSex'],
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (json['dateOfBirth'] as num).toInt(),
                isUtc: true)
            : null,
        heightInCm: json['heightInCm'],
      );
    case HealthResource.body:
      return BodyProcessedData(
        bodyMass: (json['bodyMass'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
        bodyFatPercentage: (json['bodyFatPercentage'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.workout:
      return WorkoutProcessedData(
        workouts: (json['workouts'] as List<dynamic>)
            .map((it) => _workoutFromJson(it))
            .whereType<Workout>()
            .toList(),
      );
    case HealthResource.sleep:
      return SleepProcessedData(
        sleeps: (json['sleeps'] as List<dynamic>)
            .map((it) => _sleepFromJson(it))
            .whereType<Sleep>()
            .toList(),
      );
    case HealthResource.activity:
      return ActivityProcessedData(
        activities: (json['activities'] as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.glucose:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.bloodPressure:
      return BloodPressureProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _bloodPressureSampleFromJson(it))
            .whereType<LocalBloodPressureSample>()
            .toList(),
      );
    case HealthResource.heartRate:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.heartRateVariability:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.water:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.activeEnergyBurned:
      throw Exception("Not supported on Android");
    case HealthResource.basalEnergyBurned:
      throw Exception("Not supported on Android");
    case HealthResource.steps:
      throw Exception("Not supported on Android");
    case HealthResource.distanceWalkingRunning:
      throw Exception("Not supported on Android");
    case HealthResource.vo2Max:
      throw Exception("Not supported on Android");
    case HealthResource.caffeine:
      throw Exception("Not supported on Android");
    case HealthResource.mindfulSession:
      throw Exception("Not supported on Android");
    case HealthResource.temperature:
      throw Exception("Not supported on Android");
    case HealthResource.menstrualCycle:
      throw Exception("Not supported on Android");
    case HealthResource.respiratoryRate:
      throw Exception("Not supported on Android");
    case HealthResource.meal:
      throw Exception("Not supported on Android");
    case HealthResource.afibBurden:
      throw Exception("Not supported on Android");
    case HealthResource.heartRateAlert:
      throw Exception("Not supported on Android");
    case HealthResource.electrocardiogram:
      throw Exception("Not supported on Android");
    case HealthResource.weight:
      throw Exception("Not supported");
    case HealthResource.bodyFat:
      throw Exception("Not supported");
    case HealthResource.exerciseTime:
      throw Exception("Not supported");
    case HealthResource.bodyMassIndex:
      throw Exception("Not supported");
    case HealthResource.waistCircumference:
      throw Exception("Not supported");
    case HealthResource.leanBodyMass:
      throw Exception("Not supported");
    case HealthResource.wheelchairPush:
      throw Exception("Not supported");
    case HealthResource.standHour:
      throw Exception("Not supported");
    case HealthResource.standDuration:
      throw Exception("Not supported");
    case HealthResource.sleepApneaAlert:
      throw Exception("Not supported");
    case HealthResource.sleepBreathingDisturbance:
      throw Exception("Not supported");
    case HealthResource.forcedExpiratoryVolume1:
      throw Exception("Not supported");
    case HealthResource.forcedVitalCapacity:
      throw Exception("Not supported");
    case HealthResource.peakExpiratoryFlowRate:
      throw Exception("Not supported");
    case HealthResource.inhalerUsage:
      throw Exception("Not supported");
    case HealthResource.fall:
      throw Exception("Not supported");
    case HealthResource.uvExposure:
      throw Exception("Not supported");
    case HealthResource.daylightExposure:
      throw Exception("Not supported");
    case HealthResource.handwashing:
      throw Exception("Not supported");
    case HealthResource.basalBodyTemperature:
      throw Exception("Not supported");
    case HealthResource.heartRateRecoveryOneMinute:
      throw Exception("Not supported");
  }
}

Sleep? _sleepFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Sleep(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(
        (json['startDate'] as num).toInt(),
        isUtc: true),
    endDate: DateTime.fromMillisecondsSinceEpoch(
        (json['endDate'] as num).toInt(),
        isUtc: true),
    sourceBundle: json['sourceBundle'],
    deviceModel: json['deviceModel'],
    heartRate: <LocalQuantitySample>[],
    respiratoryRate: <LocalQuantitySample>[],
    heartRateVariability: <LocalQuantitySample>[],
    oxygenSaturation: <LocalQuantitySample>[],
    restingHeartRate: <LocalQuantitySample>[],
    sleepStages: SleepStages(
      awakeSleepSamples: json['sleepStages']['awakeSleepSamples'] != null
          ? (json['sleepStages']['awakeSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      deepSleepSamples: json['sleepStages']['deepSleepSamples'] != null
          ? (json['sleepStages']['deepSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      lightSleepSamples: json['sleepStages']['lightSleepSamples'] != null
          ? (json['sleepStages']['lightSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      remSleepSamples: json['sleepStages']['remSleepSamples'] != null
          ? (json['sleepStages']['remSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      unknownSleepSamples: json['sleepStages']['unknownSleepSamples'] != null
          ? (json['sleepStages']['unknownSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      inBedSleepSamples: [],
      unspecifiedSleepSamples: [],
    ),
  );
}

Workout? _workoutFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Workout(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(
        (json['startDate'] as num).toInt(),
        isUtc: true),
    endDate: DateTime.fromMillisecondsSinceEpoch(
        (json['endDate'] as num).toInt(),
        isUtc: true),
    sourceBundle: json['sourceBundle'],
    deviceModel: json['deviceModel'],
    sport: json['sport'],
    caloriesInKiloJules: json['caloriesInKiloJules'],
    distanceInMeter: json['distanceInMeter'],
    heartRate: <LocalQuantitySample>[],
    respiratoryRate: <LocalQuantitySample>[],
  );
}

Activity? _activityFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Activity(
    distanceWalkingRunning: <LocalQuantitySample>[],
    activeEnergyBurned: <LocalQuantitySample>[],
    basalEnergyBurned: <LocalQuantitySample>[],
    steps: <LocalQuantitySample>[],
    floorsClimbed: <LocalQuantitySample>[],
    vo2Max: <LocalQuantitySample>[],
  );
}

SyncStatus mapArgumentsToStatus(List<dynamic> arguments) {
  switch (arguments[0] as String) {
    case 'failedSyncing':
      return SyncStatusFailed(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]),
          arguments[2]);
    case 'successSyncing':
      final resource =
          HealthResource.values.firstWhere((it) => it.name == arguments[1]);
      return SyncStatusSuccessSyncing(
        resource,
        fromArgument(resource, arguments[2]),
      );
    case 'nothingToSync':
      return SyncStatusNothingToSync(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncing':
      return SyncStatusSyncing(
          HealthResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncingCompleted':
      return SyncStatusCompleted();
    default:
      return SyncStatusUnknown();
  }
}

LocalBloodPressureSample? _bloodPressureSampleFromJson(e) {
  try {
    return LocalBloodPressureSample(
      systolic: _sampleFromJson(e["systolic"])!,
      diastolic: _sampleFromJson(e["diastolic"])!,
      pulse: e["pulse"] != null ? _sampleFromJson(e["pulse"]) : null,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

LocalQuantitySample? _sampleFromJson(Map<dynamic, dynamic> json) {
  try {
    return LocalQuantitySample(
      id: json['id'] as String?,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
          (json['startDate'] as num).toInt(),
          isUtc: true),
      endDate: DateTime.fromMillisecondsSinceEpoch(
          (json['endDate'] as num).toInt(),
          isUtc: true),
      type: json['type'] as String?,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

VitalException _mapException(Exception e) {
  if (e is PlatformException) {
    switch (e.code) {
      case "ClientSetup":
        return ClientSetupException(e.message ?? "");
      case "UnsupportedRegion":
        return UnsupportedRegionException(e.message ?? "");
      case "UnsupportedEnvironment":
        return UnsupportedEnvironmentException(e.message ?? "");
      case "UnsupportedResource":
        return UnsupportedResourceException(e.message ?? "");
      case "UnsupportedDataPushMode":
        return UnsupportedDataPushModeException(e.message ?? "");
      case "UnsupportedProvider":
        return UnsupportedProviderException(e.message ?? "");
      default:
        return UnknownException(e.message ?? "");
    }
  } else {
    return UnknownException(e.toString());
  }
}
