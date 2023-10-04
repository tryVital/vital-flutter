import 'package:flutter_test/flutter_test.dart';
import 'package:vital_core/services/workout_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Workouts service', () {
    test('Get workouts', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/summary/workouts/user_id_1'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
        expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
        return http.Response(
          fakeWorkoutsResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = WorkoutService.create(httpClient, '', apiKey);
      final response = await sut.getWorkouts(
        userId,
        DateTime.parse('2022-07-01'),
        endDate: DateTime.parse('2022-07-21'),
      );
      final workout1 = response.body!.workouts[0];
      expect(workout1.id, 'id_1');
      expect(workout1.timezoneOffset, -28800);
      expect(workout1.distance, 2.0);
      expect(workout1.averageSpeed, 5.81152);
      expect(workout1.sport!.id, 43);
      expect(workout1.sport!.name, 'Cycling');
      expect(workout1.source!.name, 'Peloton');
      expect(workout1.source!.slug, 'peloton');
    });

    test('Get workout stream', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), '/timeseries/workouts/$workoutId/stream');
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeStreamResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = WorkoutService.create(httpClient, '', apiKey);
      final response = await sut.getWorkoutStream(workoutId);
      final stream = response.body!;
      expect(stream.lat[0], 12.123456);
      expect(stream.lat[1], 12.234567);
      expect(stream.lng[0], 47.123456);
      expect(stream.lng[1], 47.234567);
      expect(stream.time[0], 1643054836);
      expect(stream.time[1], 1643054886);
      expect(stream.power[0], 207.0);
      expect(stream.power[1], 206.0);
    });

    test('Get workout stream nulls', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), '/timeseries/workouts/$workoutId/stream');
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeStreamResponseNulls,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = WorkoutService.create(httpClient, '', apiKey);
      final response = await sut.getWorkoutStream(workoutId);
      final stream = response.body!;
      expect(stream.altitude.length, 0);
      expect(stream.cadence.length, 0);
      expect(stream.distance.length, 0);
      expect(stream.heartrate.length, 0);
      expect(stream.lat.length, 0);
      expect(stream.lng.length, 0);
      expect(stream.power.length, 0);
      expect(stream.resistance.length, 0);
      expect(stream.time.length, 0);
      expect(stream.velocitySmooth.length, 0);
    });
  });
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';
const workoutId = 'workout_id_1';

const fakeWorkoutsResponse = '''
{
    "workouts": [
        {
            "user_id": "user_id_1",
            "user_key": "user_key_1",
            "id": "id_1",
            "title": "Cycling Workout",
            "timezone_offset": -28800,
            "average_hr": null,
            "max_hr": null,
            "distance": 2.0,
            "time_start": "2022-01-24T20:07:14+00:00",
            "time_end": "2022-01-24T20:17:14+00:00",
            "calories": 98.0,
            "sport": {
                "id": 43,
                "name": "Cycling"
            },
            "hr_zones": null,
            "moving_time": 600,
            "total_elevation_gain": null,
            "elev_high": 120.0,
            "elev_low": 100,
            "average_speed": 5.81152,
            "max_speed": 21.9,
            "average_watts": 114.0,
            "device_watts": 180,
            "max_watts": 212.0,
            "weighted_average_watts": null,
            "map": null,
            "provider_id": "b16d5dee1f83431787c2d3df8fbd50a9",
            "source": {
                "name": "Peloton",
                "slug": "peloton",
                "logo": "https://storage.googleapis.com/vital-assets/peloton.png"
            }
        },
        {
            "user_id": "user_id_1",
            "user_key": "user_key_1",
            "id": "id_2",
            "title": null,
            "timezone_offset": null,
            "average_hr": null,
            "max_hr": null,
            "distance": null,
            "time_start": "2022-01-06T16:02:46+00:00",
            "time_end": "2022-01-06T16:22:46+00:00",
            "calories": null,
            "sport": null,
            "hr_zones": null,
            "moving_time": null,
            "total_elevation_gain": null,
            "elev_high": null,
            "elev_low": null,
            "average_speed": null,
            "max_speed": null,
            "average_watts": null,
            "device_watts": null,
            "max_watts": null,
            "weighted_average_watts": null,
            "map": null,
            "provider_id": null,
            "source": null
        }
    ]
}
''';

const fakeStreamResponse = '''{
    "cadence": [
        71.0,
        74.0
    ],
    "time": [
        1643054836,
        1643054886
    ],
    "altitude": [],
    "velocity_smooth": [
        21.7,
        21.6
    ],
    "heartrate": [],
    "lat": [
      12.123456,
      12.234567
    ],
    "lng": [
      47.123456,
      47.234567
    ],
    "distance": [],
    "power": [
        207.0,
        206.0
    ],
    "resistance": [
        56.0,
        56.0
    ]
}''';

const fakeStreamResponseNulls = '''{
    "resistance": null
}''';
