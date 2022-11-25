import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_core/services/data/vitals.dart';
import 'package:vital_core/services/vitals_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Vitals service', () {
    test('Get cholesterol', () async {
      for (final type in CholesterolType.values) {
        final httpClient = createVitalsClient('/timeseries/$userId/cholesterol/${type.name}');

        final sut = VitalsService.create(httpClient, '', apiKey);
        final response = await sut.getCholesterol(
          type,
          userId,
          DateTime.parse('2022-07-01'),
          endDate: DateTime.parse('2022-07-21'),
        );
        checkMeasurements(response.body!);
      }
    });

    test('Get glucose', () async {
      final httpClient = createVitalsClient('/timeseries/$userId/glucose');

      final sut = VitalsService.create(httpClient, '', apiKey);
      final response = await sut.getGlucose(
        userId,
        DateTime.parse('2022-07-01'),
        endDate: DateTime.parse('2022-07-21'),
      );
      checkMeasurements(response.body!);
    });
  });
}

MockClient createVitalsClient(String path) {
  return MockClient((http.Request req) async {
    expect(req.url.toString(), startsWith(path));
    expect(req.method, 'GET');
    expect(req.headers['x-vital-api-key'], apiKey);
    expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
    expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
    return http.Response(
      fakeResponse,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

checkMeasurements(List<Measurement> measurements) {
  expect(measurements.length, 3);
  expect(measurements[0].id, 1);
  expect(measurements[0].value, 5.7);
  expect(measurements[0].type, 'automatic');
  expect(measurements[0].unit, 'mmol/L');

  expect(measurements[1].id, 2);
  expect(measurements[1].value, null);
  expect(measurements[1].type, null);
  expect(measurements[1].unit, null);

  expect(measurements[2].id, 3);
  expect(measurements[2].value, null);
  expect(measurements[2].type, null);
  expect(measurements[2].unit, null);
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';

const fakeResponse = '''[
    {
        "id": 1,
        "timestamp": "2022-01-01T03:16:31+00:00",
        "value": 5.7,
        "type": "automatic",
        "unit": "mmol/L"
    },
    {
        "id": 2,
        "timestamp": "2022-01-02T03:16:31+00:00",
        "value": null,
        "type": null,
        "unit": null
    },
    {
      "id": 3,
      "timestamp": "2022-01-03T03:16:31+00:00"  
    }
]''';
