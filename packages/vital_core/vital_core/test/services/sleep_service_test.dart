import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_core/services/data/sleep.dart';
import 'package:vital_core/services/sleep_service.dart';
import 'package:vital_core/services/utils/vital_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Sleep service', () {
    test('Get sleep data', () async {
      final httpClient = sleepClient(
          '/summary/sleep/user_id_1', fakeSleepDataResponse,
          validation: validateDateRange);

      final sut = SleepService.create(httpClient,
          Uri.parse("https://example.com"), VitalInterceptor(false, apiKey));
      final response = await sut.getSleepData(userId,
          DateTime.parse('2022-07-01'), DateTime.parse('2022-07-21'), null);

      expect(response.body!.sleep.length, 3);
      final sleep = response.body!.sleep[0];
      checkFirstSleep(sleep);
    });

    test('Get sleep stream series', () async {
      final httpClient = sleepClient(
          '/summary/sleep/user_id_1/stream', fakeSleepStreamSeriesResponse,
          validation: validateDateRange);

      final sut = SleepService.create(httpClient,
          Uri.parse("https://example.com"), VitalInterceptor(false, apiKey));
      final response = await sut.getSleepStreamSeries(userId,
          DateTime.parse('2022-07-01'), DateTime.parse('2022-07-21'), null);

      final sleepStreamSeries = response.body!;
      expect(sleepStreamSeries.sleep.length, 2);
      final sleep = sleepStreamSeries.sleep[0];
      checkFirstSleep(sleep);
      checkFirstSleepStream(sleep.sleepStream!);
    });

    test('Get sleep stream', () async {
      final httpClient = sleepClient(
          '/timeseries/sleep/stream_id_1/stream', fakeSleepStreamResponse);

      final sut = SleepService.create(httpClient,
          Uri.parse("https://example.com"), VitalInterceptor(false, apiKey));
      final response = await sut.getSleepStream(streamId);

      final sleepStream = response.body!;
      checkFirstSleepStream(sleepStream);
    });
  });
}

MockClient sleepClient(String path, String response,
    {Function(http.Request)? validation}) {
  return MockClient((http.Request req) async {
    expect(req.url.toString(), contains(path));
    expect(req.method, 'GET');
    validation?.call(req);
    expect(req.headers['x-vital-api-key'], apiKey);
    return http.Response(
      response,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

validateDateRange(http.Request req) {
  expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
  expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
}

checkFirstSleep(SleepData sleep) {
  expect(sleep.id, id);
  expect(sleep.userId, userId);
  expect(sleep.duration, 21480);
  expect(sleep.efficiency, 80.0);
  expect(sleep.respiratoryRate, 17.12);
  expect(sleep.source!.name, 'Oura');
  expect(sleep.source!.slug, 'oura');
}

checkFirstSleepStream(SleepStreamResponse sleepStream) {
  expect(sleepStream.hrv.length, 2);
  expect(sleepStream.heartrate.length, 1);
  expect(sleepStream.hypnogram.length, 1);
  expect(sleepStream.respiratoryRate.length, 1);
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';
const id = 'id_1';
const streamId = 'stream_id_1';

const fakeSleepDataResponse = '''{
    "sleep": [
        {
            "user_id": "user_id_1",
            "user_key": "user_id_1",
            "id": "id_1",
            "date": "2022-07-15T00:00:00+00:00",
            "bedtime_start": "2022-07-16T01:25:42+00:00",
            "bedtime_stop": "2022-07-16T07:23:42+00:00",
            "timezone_offset": 3600,
            "duration": 21480,
            "total": 17280,
            "awake": 4200,
            "light": 5970,
            "rem": 3420,
            "deep": 7890,
            "score": 58,
            "hr_lowest": 49,
            "hr_average": 58,
            "efficiency": 80.0,
            "latency": 1200,
            "temperature_delta": 0.28,
            "average_hrv": 42.0,
            "respiratory_rate": 17.12,
            "source": {
                "name": "Oura",
                "slug": "oura",
                "logo": "https://storage.googleapis.com/vital-assets/oura.png"
            },
            "sleep_stream": null
        },
        {
            "user_id": "user_id_1",
            "user_key": "user_id_1",
            "id": "id_2",
            "date": "2022-07-14T00:00:00+00:00",
            "bedtime_start": null,
            "bedtime_stop": null,
            "timezone_offset": null,
            "duration": null,
            "total": null,
            "awake": null,
            "light": null,
            "rem": null,
            "deep": null,
            "score": null,
            "hr_lowest": null,
            "hr_average": null,
            "efficiency": null,
            "latency": null,
            "temperature_delta": null,
            "average_hrv": null,
            "respiratory_rate": null,
            "source": {
                "name": null,
                "slug": null,
                "logo": null
            },
            "sleep_stream": null
        },
        {
            "user_id": "user_id_1",
            "user_key": "user_id_1",
            "id": "id_2",
            "date": "2022-07-14T00:00:00+00:00",
            "bedtime_start": null,
            "bedtime_stop": null,
            "timezone_offset": null,
            "duration": null,
            "total": null,
            "awake": null,
            "light": null,
            "rem": null,
            "deep": null,
            "score": null,
            "hr_lowest": null,
            "hr_average": null,
            "efficiency": null,
            "latency": null,
            "temperature_delta": null,
            "average_hrv": null,
            "respiratory_rate": null,
            "source": null,
            "sleep_stream": null
        }
    ]
}''';
const fakeSleepStreamSeriesResponse = '''{
    "sleep": [
        {
            "user_id": "user_id_1",
            "user_key": "user_id_1",
            "id": "id_1",
            "date": "2022-07-15T00:00:00+00:00",
            "bedtime_start": "2022-07-16T01:25:42+00:00",
            "bedtime_stop": "2022-07-16T07:23:42+00:00",
            "timezone_offset": 3600,
            "duration": 21480,
            "total": 17280,
            "awake": 4200,
            "light": 5970,
            "rem": 3420,
            "deep": 7890,
            "score": 58,
            "hr_lowest": 49,
            "hr_average": 58,
            "efficiency": 80.0,
            "latency": 1200,
            "temperature_delta": 0.28,
            "average_hrv": 42.0,
            "respiratory_rate": 17.12,
            "source": {
                "name": "Oura",
                "slug": "oura",
                "logo": "https://storage.googleapis.com/vital-assets/oura.png"
            },
            "sleep_stream": {
                "hrv": [
                    {
                        "id": 1,
                        "timestamp": "2022-07-16T00:25:42+00:00",
                        "value": 0.0,
                        "type": "automatic",
                        "unit": "rmssd"
                    },
                    {
                        "id": 2,
                        "timestamp": "2022-07-16T00:30:42+00:00",
                        "value": null,
                        "type": null,
                        "unit": null
                    }
                ],
                "heartrate": [
                    {
                        "id": 3,
                        "timestamp": "2022-07-14T00:01:00+00:00",
                        "value": 79.0,
                        "type": "automatic",
                        "unit": "bpm"
                    }
                ],
                "hypnogram": [
                    {
                        "id": 4,
                        "timestamp": "2022-07-16T00:25:42+00:00",
                        "value": 4.0,
                        "type": "automatic",
                        "unit": "vital_hypnogram"
                    }
                ],
                "respiratory_rate": [
                    {
                        "id": 5,
                        "timestamp": "2022-07-16T00:25:42+00:00",
                        "value": 4.0,
                        "type": "automatic",
                        "unit": "rate"
                    }
                ]
            }
        },
        {
            "user_id": "user_id_1",
            "user_key": "user_id_1",
            "id": "id_2",
            "date": "2022-07-14T00:00:00+00:00",
            "bedtime_start": null,
            "bedtime_stop": null,
            "timezone_offset": null,
            "duration": null,
            "total": null,
            "awake": null,
            "light": null,
            "rem": null,
            "deep": null,
            "score": null,
            "hr_lowest": null,
            "hr_average": null,
            "efficiency": null,
            "latency": null,
            "temperature_delta": null,
            "average_hrv": null,
            "respiratory_rate": null,
            "source": {
                "name": null,
                "slug": null,
                "logo": null
            },
            "sleep_stream": {}
        }
    ]
}''';
const fakeSleepStreamResponse = '''{
    "hrv": [
        {
            "id": 1,
            "timestamp": "2022-07-16T00:25:42+00:00",
            "value": 0.0,
            "type": "automatic",
            "unit": "rmssd"
        },
        {
            "id": 2,
            "timestamp": "2022-07-16T00:30:42+00:00",
            "value": null,
            "type": null,
            "unit": null
        }
    ],
    "heartrate": [
        {
            "id": 3,
            "timestamp": "2022-07-14T00:01:00+00:00",
            "value": 79.0,
            "type": "automatic",
            "unit": "bpm"
        }
    ],
    "hypnogram": [
        {
            "id": 4,
            "timestamp": "2022-07-16T00:25:42+00:00",
            "value": 4.0,
            "type": "automatic",
            "unit": "vital_hypnogram"
        }
    ],
    "respiratory_rate": [
        {
            "id": 5,
            "timestamp": "2022-07-16T00:25:42+00:00",
            "value": 4.0,
            "type": "automatic",
            "unit": "rate"
        }
    ]
}''';

const fakeSleepStreamResponseNulls = '''{
    "hrv": null,
}''';
