import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_core/exceptions.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_kit');

class VitalHealthIos extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instanceFactory = () => VitalHealthIos();
  }

  late final StreamController<SyncStatus> _streamController = StreamController(
    onListen: () async {
      Fimber.d('Healthkit subscribeToStatus (stream)');
      await _channel.invokeMethod('subscribeToStatus');
    },
    onCancel: () async {
      await _channel.invokeMethod('unsubscribeFromStatus');
    },
  );

  late final _statusStream = _streamController.stream.asBroadcastStream();

  VitalHealthIos() : super() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'sendStatus':
          Fimber.d(
              "sendStatus ${call.arguments[0]} ${call.arguments[1]} ${call.arguments[2]}");
          _streamController.sink
              .add(mapArgumentsToStatus(call.arguments as List<dynamic>));
          break;
        default:
          break;
      }
      return null;
    });
  }

  @override
  Future<bool> isAvailable() async {
    return true;
  }

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {
    Fimber.d('Healthkit configure $apiKey, $region $environment');

    await _channel.invokeMethod(
        'configureClient', [apiKey, region.name, environment.name]);
  }

  @override
  Future<void> configureHealth({required HealthConfig config}) async {
    Fimber.d('Healthkit configureHealthKit $config');
    final result = await _channel.invokeMethod('configureHealthkit', [
      config.iosConfig.backgroundDeliveryEnabled,
      config.logsEnabled,
      config.numberOfDaysToBackFill,
      config.iosConfig.dataPushMode
    ]);
    final error = _mapError(result);
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    final result = await _channel.invokeMethod('setUserId', userId);

    final error = _mapError(result);
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> cleanUp() async {
    final result = await _channel.invokeMethod('cleanUp');

    final error = _mapError(result);
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    final outcome = await _channel.invokeMethod('ask', [
      readResources.map((it) => it.name).toList(),
      writeResources.map((it) => it.name).toList()
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
  }

  @override
  Future<void> syncData({List<HealthResource>? resources}) async {
    final result = await _channel.invokeMethod(
        'syncData', resources?.map((it) => it.name).toList());

    final error = _mapError(result);
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<bool> hasAskedForPermission(HealthResource resource) async {
    final result =
        await _channel.invokeMethod('hasAskedForPermission', resource.name);

    final error = _mapError(result);
    if (error != null) {
      throw error;
    } else {
      return result as bool;
    }
  }

  @override
  Future<bool> isUserConnected(String provider) async {
    final result = await _channel.invokeMethod('isUserConnected', provider);

    final error = _mapError(result);
    if (error != null) {
      throw error;
    } else {
      return result as bool;
    }
  }

  @override
  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    final result = await _channel.invokeMethod('writeHealthKitData', [
      writeResource.name,
      value,
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch
    ]);

    final error = _mapError(result);
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<ProcessedData?> read(
      HealthResource resource, DateTime startDate, DateTime endDate) async {
    final result = await _channel.invokeMethod('read', [
      resource.name,
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch
    ]);

    if (result == null) {
      return null;
    }

    final error = _mapError(result);
    if (error != null) {
      throw error;
    } else {
      return _mapJsonToProcessedData(resource, jsonDecode(result));
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
  Stream<SyncStatus> get status => _statusStream;
}

ProcessedData _mapJsonToProcessedData(
    HealthResource resource, Map<String, dynamic> json) {
  switch (resource) {
    case HealthResource.profile:
      final rawDateOfBirth =
          json['summary']["_0"]["profile"]["_0"]['dateOfBirth'];
      return ProfileProcessedData(
        biologicalSex: json['summary']["_0"]["profile"]["_0"]['biologicalSex'],
        dateOfBirth: rawDateOfBirth != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (rawDateOfBirth as num).toInt(),
                isUtc: true)
            : null,
        heightInCm: json['summary']["_0"]["profile"]["_0"]['heightInCm'],
      );
    case HealthResource.body:
      return BodyProcessedData(
        bodyMass:
            (json['summary']["_0"]["body"]["_0"]['bodyMass'] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
        bodyFatPercentage: (json['summary']["_0"]["body"]["_0"]
                ['bodyFatPercentage'] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.workout:
      return WorkoutProcessedData(
        workouts: (json['summary']["_0"]["workout"]["_0"]['workouts']
                as List<dynamic>)
            .map((it) => _workoutFromJson(it))
            .whereType<Workout>()
            .toList(),
      );
    case HealthResource.sleep:
      return SleepProcessedData(
        sleeps: (json['summary']["_0"]["sleep"]["_0"]['sleep'] as List<dynamic>)
            .map((it) => _sleepFromJson(it))
            .whereType<Sleep>()
            .toList(),
      );
    case HealthResource.activity:
      return ActivityProcessedData(
        activities: (json['summary']["_0"]["activity"]["_0"]["activities"]
                as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.glucose:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["glucose"]["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.bloodPressure:
      return BloodPressureProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["bloodPressure"]["_0"] as List<dynamic>)
                .map((it) => _bloodPressureSampleFromSwiftJson(it))
                .whereType<LocalBloodPressureSample>()
                .toList(),
      );
    case HealthResource.heartRate:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["heartRate"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.heartRateVariability:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["heartRateVariability"]["_0"]
                as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.water:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["nutrition"]["_0"]["water"]["_0"]
                as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.caffeine:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["nutrition"]["_0"]["caffeine"]
                ["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.mindfulSession:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["mindfulSession"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.respiratoryRate:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["respiratoryRate"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.temperature:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["temperature"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.activeEnergyBurned:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["caloriesActive"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.basalEnergyBurned:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["caloriesBasal"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.distanceWalkingRunning:
      return TimeseriesProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["distance"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<LocalQuantitySample>()
                .toList(),
      );
    case HealthResource.steps:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["steps"]["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.vo2Max:
      return TimeseriesProcessedData(
        timeSeries: (json['timeSeries']["_0"]["vo2Max"]["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList(),
      );
    case HealthResource.menstrualCycle:
      throw Exception("Not supported by read()");
    case HealthResource.meal:
      throw Exception("Not supported by read()");
  }
}

Activity? _activityFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Activity(
    distanceWalkingRunning: (json['distanceWalkingRunning'] != null
        ? json['distanceWalkingRunning']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<LocalQuantitySample>()
            .toList()
        : <LocalQuantitySample>[]),
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

Sleep? _sleepFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }

  final startMillisecondsSinceEpoch = (json['startDate'] as num).toInt();
  final endMillisecondsSinceEpoch = (json['endDate'] as num).toInt();

  return Sleep(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(startMillisecondsSinceEpoch,
        isUtc: true),
    endDate: DateTime.fromMillisecondsSinceEpoch(endMillisecondsSinceEpoch,
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
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      deepSleepSamples: json['sleepStages']['deepSleepSamples'] != null
          ? (json['sleepStages']['deepSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      lightSleepSamples: json['sleepStages']['lightSleepSamples'] != null
          ? (json['sleepStages']['lightSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      remSleepSamples: json['sleepStages']['remSleepSamples'] != null
          ? (json['sleepStages']['remSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      unknownSleepSamples: json['sleepStages']['unknownSleepSamples'] != null
          ? (json['sleepStages']['unknownSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      inBedSleepSamples: json['sleepStages']['inBedSleepSamples'] != null
          ? (json['sleepStages']['inBedSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
      unspecifiedSleepSamples: json['sleepStages']['unspecifiedSleepSamples'] !=
              null
          ? (json['sleepStages']['unspecifiedSleepSamples'] as List<dynamic>)
              .map((it) => _sampleFromSwiftJson(it))
              .whereType<LocalQuantitySample>()
              .toList()
          : <LocalQuantitySample>[],
    ),
  );
}

Workout? _workoutFromJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }

  final startMillisecondsSinceEpoch = (json['startDate'] as num).toInt();
  final endMillisecondsSinceEpoch = (json['endDate'] as num).toInt();

  return Workout(
    id: json['id'],
    startDate: DateTime.fromMillisecondsSinceEpoch(startMillisecondsSinceEpoch,
        isUtc: true),
    endDate: DateTime.fromMillisecondsSinceEpoch(endMillisecondsSinceEpoch,
        isUtc: true),
    sourceBundle: json['sourceBundle'],
    deviceModel: json['deviceModel'],
    sport: json['sport'],
    caloriesInKiloJules: json['calories'],
    distanceInMeter: json['distance'],
    heartRate: <LocalQuantitySample>[],
    respiratoryRate: <LocalQuantitySample>[],
  );
}

LocalBloodPressureSample? _bloodPressureSampleFromSwiftJson(e) {
  try {
    return LocalBloodPressureSample(
      systolic: _sampleFromSwiftJson(e["systolic"])!,
      diastolic: _sampleFromSwiftJson(e["diastolic"])!,
      pulse: e["pulse"] != null ? _sampleFromSwiftJson(e["pulse"]) : null,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

LocalQuantitySample? _sampleFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }

  try {
    final startMillisecondsSinceEpoch = (json['startDate'] as num).toInt();
    final endMillisecondsSinceEpoch = (json['endDate'] as num).toInt();

    return LocalQuantitySample(
      id: json['id'] as String?,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
          startMillisecondsSinceEpoch,
          isUtc: true),
      endDate: DateTime.fromMillisecondsSinceEpoch(endMillisecondsSinceEpoch,
          isUtc: true),
      type: json['type'] as String?,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

VitalException? _mapError(dynamic arguments) {
  if (arguments is! Map) return null;

  final code = arguments.containsKey("code") ? arguments["code"] : null;
  final message =
      arguments.containsKey("message") ? arguments["message"] : null;

  if (code == null || message == null) {
    return null;
  } else {
    switch (code) {
      case "UnsupportedRegion":
        return UnsupportedRegionException(message);
      case "UnsupportedEnvironment":
        return UnsupportedEnvironmentException(message);
      case "UnsupportedResource":
        return UnsupportedResourceException(message);
      case "UnsupportedDataPushMode":
        return UnsupportedDataPushModeException(message);
      case "UnsupportedProvider":
        return UnsupportedProviderException(message);
    }

    return UnknownException(code + " " + message);
  }
}
