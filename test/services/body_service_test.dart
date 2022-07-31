import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_flutter/services/body_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Body service', () {
    test('Get body data', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/summary/body/user_id_1'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
        expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
        return http.Response(
          fakeBodyResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = BodyService.create(httpClient, '', apiKey);
      final response = await sut.getBodyData(userId, DateTime.parse('2022-07-01'), DateTime.parse('2022-07-21'), null);

      expect(response.body!.body.length, 2);
      final bodyData = response.body!.body[0];
      expect(bodyData.id, 'id_1');
      expect(bodyData.userId, userId);
      expect(bodyData.fat, 0);
      expect(bodyData.weight, 80);
      expect(bodyData.source.name, 'Fitbit');
      expect(bodyData.source.slug, 'fitbit');

      final bodyData2 = response.body!.body[1];
      expect(bodyData2.id, 'id_2');
      expect(bodyData2.userId, null);
      expect(bodyData2.fat, null);
      expect(bodyData2.weight, null);
      expect(bodyData2.source.name, null);
      expect(bodyData2.source.slug, null);
    });
  });
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';

const fakeBodyResponse = '''{
    "body": [
        {
            "user_id": "user_id_1",
            "user_key": "user_key_1",
            "id": "id_1",
            "date": "2022-07-19T00:00:00+00:00",
            "weight": 80.0,
            "fat": 0.0,
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
            "date": "2022-07-18T00:00:00+00:00",
            "weight": null,
            "fat": null,
            "source": {
                "name": null,
                "slug": null,
                "logo": null
            }
        }
    ]
}''';
