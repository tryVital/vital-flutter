import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_client/region.dart';
import 'package:vital_client/services/link_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Link service', () {
    test('Create link token', () async {
      final httpClient =
          linkClient('POST', '/link/token', fakeCreateLinkResponse);

      final sut = LinkService.create(httpClient, '', apiKey);
      final response =
          await sut.createLink(userId, 'strava', 'callback://vital');

      final linkTokenResponse = response.body!;
      expect(linkTokenResponse.linkToken, linkToken);
    });

    test('Link oauth provider', () async {
      final httpClient = linkClient(
          'GET', '/link/provider/oauth/strava', fakeLinkOauthProviderResponse);

      final sut = LinkService.create(httpClient, '', apiKey);
      final response = await sut.oauthProvider(
        provider: 'strava',
        linkToken: linkToken,
      );

      final oauthResponse = response.body!;
      expect(oauthResponse.oauthUrl, 'https://www.strava.com/oauth/');
      expect(oauthResponse.isActive, true);
      expect(oauthResponse.authType, 'oauth');
      expect(oauthResponse.id, 5);
    });

    test('Link email provider', () async {
      final httpClient = linkClient(
          'POST', '/link/provider/email/strava', fakeEmailLinkResponse);

      final sut = LinkService.create(httpClient, '', apiKey);
      final response = await sut.emailProvider(
        provider: 'strava',
        email: 'test@test.com',
        region: Region.us,
        linkToken: linkToken,
      );

      final result = response.body!;
      expect(result.success, true);
      expect(result.redirectUrl, 'callback://vital');
    });

    test('Link password provider', () async {
      final httpClient = linkClient(
          'POST', '/link/provider/password/strava', fakeEmailLinkResponse);

      final sut = LinkService.create(httpClient, '', apiKey);
      final response = await sut.passwordProvider(
        provider: 'strava',
        username: 'username',
        password: 'password',
        redirectUrl: 'callback://vital',
        linkToken: linkToken,
      );

      final result = response.body!;
      expect(result.success, true);
      expect(result.redirectUrl, 'callback://vital');
    });
  });
}

MockClient linkClient(String method, String path, String response) {
  return MockClient((http.Request req) async {
    expect(req.url.toString(), path);
    expect(req.method, method);
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
const linkToken = 'linkTokenSample';

const fakeCreateLinkResponse = '''{
    "link_token": "linkTokenSample"
}''';

const fakeLinkOauthProviderResponse = '''{
    "name": "Strava",
    "slug": "strava",
    "description": "Activity Social Network",
    "logo": "https://storage.googleapis.com/vital-assets/strava.png",
    "group": null,
    "oauth_url": "https://www.strava.com/oauth/",
    "auth_type": "oauth",
    "is_active": true,
    "id": 5
}''';

const fakeEmailLinkResponse =
    '''{"success":true,"redirect_url":"callback://vital"}''';
