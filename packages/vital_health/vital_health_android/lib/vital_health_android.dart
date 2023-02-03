import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vital_core/exceptions.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_connect');

class VitalHealthAndroid extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instance = VitalHealthAndroid();
  }

  final _statusSubject = PublishSubject<SyncStatus>();

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {
    Fimber.d('Health Connect configure $apiKey, $region $environment');

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "status":
          {
            _statusSubject
                .add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          }
      }
    });

    await _channel.invokeMethod('configureClient', <String, dynamic>{
      "apiKey": apiKey,
      "region": region.name,
      "environment": environment.name,
    });
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
  Future<void> setUserId(String userId) async {
    try {
      await _channel.invokeMethod('setUserId', <String, dynamic>{
        "userId": userId,
      });
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> cleanUp() async {
    try {
      await _channel.invokeMethod('cleanUp');
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<PermissionOutcome> askForResources(
      List<HealthResource> resources) async {
    try {
      return ask(resources, []);
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    try {
      final result =
          await _channel.invokeMethod('askForResources', <String, dynamic>{
        "readResources": readResources.map((e) => e.name).toList(),
        "writeResources": writeResources.map((e) => e.name).toList(),
      });

      return result
          ? PermissionOutcome.success()
          : PermissionOutcome.failure(result);
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
      return await _channel.invokeMethod('hasAskedForPermission', resource.name)
          as bool;
    } on Exception catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<bool> isUserConnected(String provider) async {
    try {
      return await _channel.invokeMethod('isUserConnected', provider) as bool;
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
  Stream<SyncStatus> get status => _statusSubject.stream;
}

ProcessedData _mapJsonToProcessedData(
    HealthResource resource, Map<String, dynamic> json) {
  switch (resource) {
    case HealthResource.profile:
      return ProfileProcessedData(
        biologicalSex: json['biologicalSex'],
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['dateOfBirth'])
            : null,
        heightInCm: json['heightInCm'],
      );
    case HealthResource.body:
      return BodyProcessedData(
        bodyMass: (json['bodyMass'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList(),
        bodyFatPercentage: (json['bodyFatPercentage'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
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
    case HealthResource.activeEnergyBurned:
      return ActiveEnergyBurnedProcessedData(
        activities: (json['activities'] as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.basalEnergyBurned:
      return BasalEnergyBurnedProcessedData(
        activities: (json['activities'] as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );

    case HealthResource.steps:
      return StepsProcessedData(
        activities: (json['activities'] as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.glucose:
      return GlucoseProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.bloodPressure:
      return BloodPressureProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _bloodPressureSampleFromJson(it))
            .whereType<BloodPressureSample>()
            .toList(),
      );
    case HealthResource.heartRate:
      return HeartRateProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.heartRateVariability:
      return HeartRateVariabilityProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.water:
      return WaterProcessedData(
        timeSeries: (json['timeSeries'] as List<dynamic>)
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.caffeine:
      throw Exception("Not supported on Android");
    case HealthResource.mindfulSession:
      throw Exception("Not supported on Android");
  }
}

Sleep? _sleepFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Sleep(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
    endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
    sourceBundle: json['sourceBundle'],
    deviceModel: json['deviceModel'],
    heartRate: (json['heartRate'] != null
        ? json['heartRate']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    respiratoryRate: (json['respiratoryRate'] != null
        ? json['respiratoryRate']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    heartRateVariability: (json['heartRateVariability'] != null
        ? json['heartRateVariability']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    oxygenSaturation: (json['oxygenSaturation'] != null
        ? json['oxygenSaturation']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    restingHeartRate: (json['restingHeartRate'] != null
        ? json['restingHeartRate']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    sleepStages: SleepStages(
      awakeSleepSamples: json['sleepStages']['awakeSleepSamples'] != null
          ? jsonDecode(json['sleepStages']['awakeSleepSamples'])
              .map((it) => _sampleFromJson(it))
              .whereType<QuantitySample>()
              .toList()
          : <QuantitySample>[],
      deepSleepSamples: json['sleepStages']['deepSleepSamples'] != null
          ? jsonDecode(json['sleepStages']['deepSleepSamples'])
              .map((it) => _sampleFromJson(it))
              .whereType<QuantitySample>()
              .toList()
          : <QuantitySample>[],
      lightSleepSamples: json['sleepStages']['lightSleepSamples'] != null
          ? jsonDecode(json['sleepStages']['lightSleepSamples'])
              .map((it) => _sampleFromJson(it))
              .whereType<QuantitySample>()
              .toList()
          : <QuantitySample>[],
      remSleepSamples: json['sleepStages']['remSleepSamples'] != null
          ? jsonDecode(json['sleepStages']['remSleepSamples'])
              .map((it) => _sampleFromJson(it))
              .whereType<QuantitySample>()
              .toList()
          : <QuantitySample>[],
      unknownSleepSamples: json['sleepStages']['unknownSleepSamples'] != null
          ? jsonDecode(json['sleepStages']['unknownSleepSamples'])
              .map((it) => _sampleFromJson(it))
              .whereType<QuantitySample>()
              .toList()
          : <QuantitySample>[],
    ),
  );
}

Workout? _workoutFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Workout(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
    endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
    sourceBundle: json['sourceBundle'],
    deviceModel: json['deviceModel'],
    sport: json['sport'],
    caloriesInKiloJules: json['caloriesInKiloJules'],
    distanceInMeter: json['distanceInMeter'],
    heartRate: (json['heartRate'] != null
        ? json['heartRate']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    respiratoryRate: (json['respiratoryRate'] != null
        ? json['respiratoryRate']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
  );
}

Activity? _activityFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Activity(
    distanceWalkingRunning: (json['distanceWalkingRunning'] != null
        ? json['distanceWalkingRunning']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    activeEnergyBurned: (json['activeEnergyBurned'] != null
        ? json['activeEnergyBurned']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    basalEnergyBurned: (json['basalEnergyBurned'] != null
        ? json['basalEnergyBurned']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    steps: (json['steps'] != null
        ? json['steps']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    floorsClimbed: (json['floorsClimbed'] != null
        ? json['floorsClimbed']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    vo2Max: (json['vo2Max'] != null
        ? json['vo2Max']
            .map((it) => _sampleFromJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
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

BloodPressureSample? _bloodPressureSampleFromJson(e) {
  try {
    return BloodPressureSample(
      systolic: _sampleFromJson(e["systolic"])!,
      diastolic: _sampleFromJson(e["diastolic"])!,
      pulse: e["pulse"] != null ? _sampleFromJson(e["pulse"]) : null,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

QuantitySample? _sampleFromJson(Map<dynamic, dynamic> json) {
  try {
    return QuantitySample(
      id: json['id'] as String?,
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int,
          isUtc: true),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate'] as int,
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
