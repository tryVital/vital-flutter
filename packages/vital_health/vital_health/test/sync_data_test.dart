import 'package:flutter_test/flutter_test.dart';
import 'package:vital_client/samples.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Sync data', () {
    test('Activity sync arguments', () async {
      final result = mapArgumentsToStatus(activitySuccessSyncingArguments);

      expect(result, isA<SyncStatusSuccessSyncing>());
      expect(result.status, SyncStatusType.successSyncing);
      final data = (result as SyncStatusSuccessSyncing).data;
      expect(data, isA<List<ActivitySummary>>());
      expect((data as List<ActivitySummary>).length, 2);
    });

    test('Profile sync arguments', () async {
      final result = mapArgumentsToStatus(profileSuccessSyncingArguments);

      expect(result, isA<SyncStatusSuccessSyncing>());
      expect(result.status, SyncStatusType.successSyncing);
      final data = (result as SyncStatusSuccessSyncing).data;
      expect(data, isA<ProfileSummary>());
      expect((data as ProfileSummary).biologicalSex, BiologicalSex.male);
      expect(data.dateOfBirth!.year, 1987);
      expect(data.dateOfBirth!.month, 7);
      expect(data.dateOfBirth!.day, 31);
    });

    test('Glucose sync arguments', () async {
      final result = mapArgumentsToStatus(glucoseSuccessSyncingArguments);

      expect(result, isA<SyncStatusSuccessSyncing>());
      expect(result.status, SyncStatusType.successSyncing);
      final data = (result as SyncStatusSuccessSyncing).data;
      expect(data, isA<List<QuantitySample>>());
      expect((data as List<QuantitySample>).length, 1);
    });

    test('Heart rate sync arguments', () async {
      final result = mapArgumentsToStatus(heartRateSuccessSyncingArguments);

      expect(result, isA<SyncStatusSuccessSyncing>());
      expect(result.status, SyncStatusType.successSyncing);
      final data = (result as SyncStatusSuccessSyncing).data;
      expect(data, isA<List<QuantitySample>>());
      expect((data as List<QuantitySample>).length, 1);
    });

    test('Blood pressure sync arguments', () async {
      final result = mapArgumentsToStatus(bloodPressureSuccessSyncingArguments);

      expect(result, isA<SyncStatusSuccessSyncing>());
      expect(result.status, SyncStatusType.successSyncing);
      final data = (result as SyncStatusSuccessSyncing).data;
      expect(data, isA<List<BloodPressureSample>>());
      expect((data as List<BloodPressureSample>).length, 1);
    });
  });
}

final profileSuccessSyncingArguments = [
  'successSyncing',
  'profile',
  '''
    {
        "biologicalSex": "male",
        "dateOfBirth": "1987-07-31T00:00:00Z"
    }'''
];

final activitySuccessSyncingArguments = [
  'successSyncing',
  'activity',
  '''
[
        {
            "vo2Max": [],
            "floorsClimbed": [],
            "activeEnergyBurned": [],
            "steps": [
                {
                    "unit": "",
                    "endDate": "2022-07-28T18:46:00Z",
                    "id": "4F876870-B8A4-4756-82A7-0757E0248A54",
                    "startDate": "2022-07-28T18:46:00Z",
                    "value": 5000,
                    "type": "manual",
                    "sourceBundle": "com.apple.Health"
                }
            ],
            "date": "2022-07-28T00:00:00Z",
            "distanceWalkingRunning": [],
            "basalEnergyBurned": []
        },
        {
            "vo2Max": [],
            "floorsClimbed": [],
            "activeEnergyBurned": [],
            "steps": [
                {
                    "unit": "",
                    "endDate": "2022-07-29T18:46:00Z",
                    "id": "C88E799B-4A50-411D-BADD-A098582C1BC1",
                    "startDate": "2022-07-29T18:46:00Z",
                    "value": 5000,
                    "type": "manual",
                    "sourceBundle": "com.apple.Health"
                },
                {
                    "unit": "",
                    "endDate": "2022-07-29T18:46:00Z",
                    "id": "55DB5E92-70D7-4D8B-BEB2-386F838D8174",
                    "startDate": "2022-07-29T18:46:00Z",
                    "value": 4500,
                    "type": "manual",
                    "sourceBundle": "com.apple.Health"
                }
            ],
            "date": "2022-07-29T00:00:00Z",
            "distanceWalkingRunning": [],
            "basalEnergyBurned": []
        }
    ]
'''
];

final glucoseSuccessSyncingArguments = [
  'successSyncing',
  'glucose',
  '''
    [
        {
            "unit": "mmol/L",
            "endDate": "2022-07-30T16:50:00Z",
            "id": "C13F38F6-D80B-446B-AD40-80B1B21D287A",
            "startDate": "2022-07-30T16:50:00Z",
            "value": 0.055507486072600004,
            "type": "manual",
            "sourceBundle": "com.apple.Health"
        }
    ]'''
];

final heartRateSuccessSyncingArguments = [
  'successSyncing',
  'heartRate',
  '''
   [
        {
            "unit": "bpm",
            "endDate": "2022-07-30T23:00:00Z",
            "id": "6C0E39E4-6C3E-4C3B-8C06-52C5185D9BB3",
            "startDate": "2022-07-30T23:00:00Z",
            "value": 80,
            "type": "manual",
            "sourceBundle": "com.apple.Health"
        }
    ]'''
];

final bloodPressureSuccessSyncingArguments = [
  'successSyncing',
  'bloodPressure',
  '''
    [
        {
            "systolic": {
                "unit": "mmHg",
                "endDate": "2022-07-30T22:59:00Z",
                "id": "027261F2-488E-4507-8108-24BEAD21CE85",
                "startDate": "2022-07-30T22:59:00Z",
                "value": 120,
                "type": "manual",
                "sourceBundle": "com.apple.Health"
            },
            "diastolic": {
                "unit": "mmHg",
                "endDate": "2022-07-30T22:59:00Z",
                "id": "54EDCF72-BC39-404E-B539-D1D5C7732AED",
                "startDate": "2022-07-30T22:59:00Z",
                "value": 80,
                "type": "manual",
                "sourceBundle": "com.apple.Health"
            }
        }
    ]
  '''
];
