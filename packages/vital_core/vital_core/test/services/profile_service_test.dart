import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_core/services/profile_service.dart';
import 'package:vital_core/services/utils/vital_interceptor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Profile service', () {
    test('Get profile', () async {
      final httpClient = profileClient(fakeProfileResponse);

      final sut = ProfileService.create(httpClient,
          Uri.parse("https://example.com"), VitalInterceptor(false, apiKey));
      final response = await sut.getProfile(userId, null);

      final profile = response.body!;
      expect(profile.id, userId);
      expect(profile.userId, userId);
      expect(profile.height, 180);
      expect(profile.source!.name, 'Oura');
      expect(profile.source!.slug, 'oura');
    });

    test('Get profile nulls', () async {
      final httpClient = profileClient(fakeProfileResponseNulls);

      final sut = ProfileService.create(httpClient,
          Uri.parse("https://example.com"), VitalInterceptor(false, apiKey));
      final response = await sut.getProfile(userId, null);

      final profile = response.body!;
      expect(profile.id, userId);
      expect(profile.userId, userId);
      expect(profile.height, null);
      expect(profile.source, null);
    });
  });
}

MockClient profileClient(String response) {
  return MockClient((http.Request req) async {
    expect(req.url.toString(), contains('/summary/profile/user_id_1'));
    expect(req.method, 'GET');
    expect(req.headers['x-vital-api-key'], apiKey);
    return http.Response(
      response,
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

const apiKey = 'API_KEY';
const userId = 'user_id_1';

const fakeProfileResponse = '''{
    "user_id": "user_id_1",
    "user_key": "user_key_1",
    "id": "user_id_1",
    "height": 180,
    "source": {
        "name": "Oura",
        "slug": "oura",
        "logo": "https://storage.googleapis.com/vital-assets/oura.png"
    }
}''';

const fakeProfileResponseNulls = '''{
    "user_id": "user_id_1",
    "user_key": null,
    "id": "user_id_1",
    "height": null,
    "source": null
}''';
