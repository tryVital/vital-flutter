import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_flutter/services/activity_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Activity service', () {
    test('Get activities', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/summary/activity/user_id_1'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
        expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
        return http.Response(
          fakeActivityResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = ActivityService.create(httpClient, '', apiKey);
      final response = await sut.getActivity(userId, DateTime.parse('2022-07-01'), DateTime.parse('2022-07-21'), null);

      expect(response.body!.activity.length, 2);
      final activity = response.body!.activity[0];
      expect(activity.id, 'id_1');
      expect(activity.userId, userId);
      expect(activity.steps, 0);
      expect(activity.caloriesTotal, 1565.0);
      expect(activity.caloriesActive, 1565.0);
      expect(activity.source.name, 'Fitbit');
      expect(activity.source.slug, 'fitbit');
    });
  });
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';

const fakeActivityResponse = '''{
    "activity": [
        {
            "user_id": "user_id_1",
            "user_key": "user_key_1",
            "id": "id_1",
            "date": "2022-07-22T00:00:00+00:00",
            "calories_total": 1565.0,
            "calories_active": 1565.0,
            "steps": 0,
            "daily_movement": 0.0,
            "low": 0.0,
            "medium": 0.0,
            "high": 0.0,
            "source": {
                "name": "Fitbit",
                "slug": "fitbit",
                "logo": "https://storage.googleapis.com/vital-assets/fitbit.png"
            }
        },
        {
            "user_id": null,
            "user_key": null,
            "id": "id_2",
            "date": "2022-07-22T00:00:00+00:00",
            "calories_total": null,
            "calories_active": null,
            "steps": null,
            "daily_movement": null,
            "low": null,
            "medium": null,
            "high": null,
            "source": {
                "name": null,
                "slug": null,
                "logo": null
            }
        }
    ]
    }''';
