import 'dart:async';
import 'dart:convert';

import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:vital_core/samples.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

const _channel = MethodChannel('vital_health_kit');

final _swiftTimeStart = DateTime.utc(2001, 1, 1, 0, 0, 0, 0, 0);

class VitalHealthIos extends VitalHealthPlatform {
  static void registerWith() {
    VitalHealthPlatform.instance = VitalHealthIos();
  }

  late final StreamController<SyncStatus> _streamController = StreamController(
    onListen: () async {
      _statusSubscribed = true;
      if (_healthKitConfigured) {
        Fimber.d('Healthkit subscribeToStatus (stream)');
        await _channel.invokeMethod('subscribeToStatus');
      }
    },
    onCancel: () async {
      _statusSubscribed = false;
      await _channel.invokeMethod('unsubscribeFromStatus');
    },
  );

  late final _statusStream = _streamController.stream.asBroadcastStream();

  var _statusSubscribed = false;
  var _healthKitConfigured = false;

  @override
  Future<void> configureClient(
      String apiKey, Region region, Environment environment) async {
    Fimber.d('Healthkit configure $apiKey, $region $environment');

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

    await _channel.invokeMethod(
        'configureClient', [apiKey, region.name, environment.name]);
  }

  @override
  Future<void> configureHealth({required HealthConfig config}) async {
    Fimber.d('Healthkit configureHealthKit $config');
    await _channel.invokeMethod('configureHealthkit', [
      config.iosConfig.backgroundDeliveryEnabled,
      config.logsEnabled,
      config.numberOfDaysToBackFill,
      config.iosConfig.dataPushMode
    ]);
    _healthKitConfigured = true;
    if (_statusSubscribed) {
      Fimber.d('Healthkit subscribeToStatus (configure)');
      await _channel.invokeMethod('subscribeToStatus');
    }
  }

  @override
  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', userId);
  }

  @override
  Future<void> cleanUp() async {
    await _channel.invokeMethod('cleanUp');
  }

  @override
  Future<PermissionOutcome> askForResources(
      List<HealthResource> resources) async {
    return ask(resources, []);
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
    await _channel.invokeMethod(
        'syncData', resources?.map((it) => it.name).toList());
  }

  @override
  Future<bool> hasAskedForPermission(HealthResource resource) async {
    return await _channel.invokeMethod('hasAskedForPermission', resource.name)
        as bool;
  }

  @override
  Future<bool> isUserConnected(String provider) async {
    return await _channel.invokeMethod('isUserConnected', provider) as bool;
  }

  @override
  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) async {
    return await _channel.invokeMethod('writeHealthKitData', [
      writeResource.name,
      value,
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch
    ]);
  }

  @override
  Future<ProcessedData> read(
      HealthResource resource, DateTime startDate, DateTime endDate) async {
    final result = await _channel.invokeMethod('read', [
      resource.name,
      startDate.millisecondsSinceEpoch,
      endDate.millisecondsSinceEpoch
    ]);

    return _mapJsonToProcessedData(resource, jsonDecode(result));
  }

  @override
  Stream<SyncStatus> get status => _statusStream;
}

ProcessedData _mapJsonToProcessedData(
    HealthResource resource, Map<String, dynamic> json) {
  switch (resource) {
    case HealthResource.profile:
      return ProfileProcessedData(
        biologicalSex: json['biologicalSex'],
        dateOfBirth: json['dateOfBirth'],
        heightInCm: json['heightInCm'],
      );
    case HealthResource.body:
      return BodyProcessedData(
        bodyMass:
            (json['summary']["_0"]["body"]["_0"]['bodyMass'] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<QuantitySample>()
                .toList(),
        bodyFatPercentage: (json['summary']["_0"]["body"]["_0"]
                ['bodyFatPercentage'] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.workout:
      return WorkoutProcessedData(
        workouts: (json['summary']["_0"]["workout"]["_0"]["workouts"]
                as List<dynamic>)
            .map((it) => _workoutFromSwiftJson(it))
            .whereType<Workout>()
            .toList(),
      );
    case HealthResource.sleep:
      return SleepProcessedData(
        sleeps: [], //TODO handle it in VIT-2412
      );
    case HealthResource.activity:
      return ActivityProcessedData(
        activities: (json['summary']["_0"]["activity"]["_0"]["activities"]
                as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.activeEnergyBurned:
      return ActiveEnergyBurnedProcessedData(
        activities: (json['summary']["_0"]["activity"]["_0"]["activities"]
                as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.basalEnergyBurned:
      return BasalEnergyBurnedProcessedData(
        activities: (json['summary']["_0"]["activity"]["_0"]["activities"]
                as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );

    case HealthResource.steps:
      return StepsProcessedData(
        activities: (json['summary']["_0"]["activity"]["_0"]["activities"]
                as List<dynamic>)
            .map((it) => _activityFromSwiftJson(it))
            .whereType<Activity>()
            .toList(),
      );
    case HealthResource.glucose:
      return GlucoseProcessedData(
        timeSeries: (json['timeSeries']["_0"]["glucose"]["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.bloodPressure:
      return BloodPressureProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["bloodPressure"]["_0"] as List<dynamic>)
                .map((it) => _bloodPressureSampleFromSwiftJson(it))
                .whereType<BloodPressureSample>()
                .toList(),
      );
    case HealthResource.heartRate:
      return HeartRateProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["heartRate"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<QuantitySample>()
                .toList(),
      );
    case HealthResource.water:
      return WaterProcessedData(
        timeSeries: (json['timeSeries']["_0"]["nutrition"]["_0"]["water"]["_0"]
                as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.caffeine:
      return CaffeineProcessedData(
        timeSeries: (json['timeSeries']["_0"]["nutrition"]["_0"]["caffeine"]
                ["_0"] as List<dynamic>)
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList(),
      );
    case HealthResource.mindfulSession:
      return MindfulSessionProcessedData(
        timeSeries:
            (json['timeSeries']["_0"]["mindfulSession"]["_0"] as List<dynamic>)
                .map((it) => _sampleFromSwiftJson(it))
                .whereType<QuantitySample>()
                .toList(),
      );
  }
}

Workout? _workoutFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }

  final startMillisecondsSinceEpoch = (json['startDate'] as int) * 1000;
  final endMillisecondsSinceEpoch = (json['endDate'] as int) * 1000;

  return Workout(
      id: json['id'],
      startDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + startMillisecondsSinceEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + endMillisecondsSinceEpoch),
      sourceBundle: json['sourceBundle'],
      deviceModel: json['deviceModel'],
      sport: json['sport'],
      caloriesInKiloJules: json['calories'],
      distanceInMeter: json['distance'],
      heartRate: (json['heartRate'] as List<dynamic>)
          .map((it) => _sampleFromSwiftJson(it))
          .whereType<QuantitySample>()
          .toList(),
      respiratoryRate: (json['respiratoryRate'] as List<dynamic>)
          .map((it) => _sampleFromSwiftJson(it))
          .whereType<QuantitySample>()
          .toList());
}

Activity? _activityFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Activity(
    distanceWalkingRunning: (json['distanceWalkingRunning'] != null
        ? json['distanceWalkingRunning']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    activeEnergyBurned: (json['activeEnergyBurned'] != null
        ? json['activeEnergyBurned']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    basalEnergyBurned: (json['basalEnergyBurned'] != null
        ? json['basalEnergyBurned']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    steps: (json['steps'] != null
        ? json['steps']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    floorsClimbed: (json['floorsClimbed'] != null
        ? json['floorsClimbed']
            .map((it) => _sampleFromSwiftJson(it))
            .whereType<QuantitySample>()
            .toList()
        : <QuantitySample>[]),
    vo2Max: (json['vo2Max'] != null
        ? json['vo2Max']
            .map((it) => _sampleFromSwiftJson(it))
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

BloodPressureSample? _bloodPressureSampleFromSwiftJson(e) {
  try {
    return BloodPressureSample(
      systolic: _sampleFromSwiftJson(e["systolic"])!,
      diastolic: _sampleFromSwiftJson(e["diastolic"])!,
      pulse: _sampleFromSwiftJson(e["pulse"]),
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}

QuantitySample? _sampleFromSwiftJson(Map<dynamic, dynamic>? json) {
  if (json == null) {
    return null;
  }

  try {
    final startMillisecondsSinceEpoch = (json['startDate'] as int) * 1000;
    final endMillisecondsSinceEpoch = (json['endDate'] as int) * 1000;

    return QuantitySample(
      id: json['id'] as String?,
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + startMillisecondsSinceEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(
          _swiftTimeStart.millisecondsSinceEpoch + endMillisecondsSinceEpoch),
      type: json['type'] as String,
    );
  } catch (e, stacktrace) {
    Fimber.i("Error parsing sample: $e $stacktrace");
    return null;
  }
}
