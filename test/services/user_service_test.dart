import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/services/user_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('User service', () {
    test('Get all users', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeUsersResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.getAll();
      final users = response.body!.users;
      expect(users.length, 2);
      final user = users[0];
      validateFirstUser(user);

      expect(users[1].connectedSources.length, 0);
    });

    test('Get user', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/$userId'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeUserResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.getUser(userId);
      validateFirstUser(response.body!);
    });

    test('Resolve user', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/key/User%20Name'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeUserResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.resolveUser(userName);
      validateFirstUser(response.body!);
    });

    test('Get providers', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/providers/$userId'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeProvidersResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.getProviders(userId);
      final provider = response.body!.providers[0];
      expect(provider.name, 'Fitbit');
      expect(provider.slug, 'fitbit');
    });

    test('Get refresh user', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/refresh/$userId'));
        expect(req.method, 'POST');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeRefreshResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.refreshUser(userId);
      expect(response.body!.refreshedSources.length, 5);
      expect(response.body!.failedSources.length, 3);
    });

    test('Create user', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/key'));
        expect(req.method, 'POST');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeCreateUserResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.createUser(userName);
      final user = response.body!;
      expect(user.userId, userId);
      expect(user.userKey, userKey);
      expect(user.clientUserId, clientUserId);
    });

    test('Delete user', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/$userId'));
        expect(req.method, 'DELETE');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeDeleteUserResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.deleteUser(userId);
      expect(response.body!.success, true);
    });

    test('Deregister provider', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/user/$userId/strava'));
        expect(req.method, 'DELETE');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeDeregisterProviderResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = UserService.create(httpClient, '', apiKey);
      final response = await sut.deregisterProvider(userId, 'strava');
      expect(response.body!.success, true);
    });
  });
}

validateFirstUser(User user) {
  expect(user.userId, userId);
  expect(user.userKey, userKey);
  expect(user.clientUserId, clientUserId);
  expect(user.teamId, teamId);
  expect(user.connectedSources.length, 3);
  expect(user.connectedSources[0].source!.name, 'Fitbit');
  expect(user.connectedSources[0].source!.slug, 'fitbit');
}

const userId = 'user_id_1';
const userKey = 'user_key_1';
const teamId = 'team_id_1';
const clientUserId = 'Test 1';
const userName = 'User Name';
const apiKey = 'API_KEY';

const fakeUsersResponse = '''{
  "users": [
    {
      "user_id": "user_id_1",
      "user_key": "user_key_1",
      "team_id": "team_id_1",
      "client_user_id": "Test 1",
      "created_on": "2021-04-02T16:03:11.847830+00:00",
      "connected_sources": [
        {
          "source": {
            "name": "Fitbit",
            "slug": "fitbit",
            "logo": "https://storage.googleapis.com/vital-assets/fitbit.png"
          },
          "created_on": "2022-06-15T13:44:34.770879+00:00"
        },
        {
          "source": {
            "name": null,
            "slug": null,
            "logo": null
          },
          "created_on": "2022-03-01T12:25:15.558385+00:00"
        },
        {
          "source": null,
          "created_on": null
        }
      ]
    },
    {
      "user_id": "user_id_2",
      "user_key": "user_key_2",
      "team_id": "team_id_2",
      "client_user_id": "Test 2",
      "created_on": "2021-12-01T22:43:32.570793+00:00",
      "connected_sources": null
    }
  ]
}''';

const fakeUserResponse = '''
{
    "user_id": "user_id_1",
    "user_key": "user_key_1",
    "team_id": "team_id_1",
    "client_user_id": "Test 1",
    "created_on": "2021-04-02T16:03:11.847830+00:00",
    "connected_sources": [
        {
            "source": {
                "name": "Fitbit",
                "slug": "fitbit",
                "logo": "https://storage.googleapis.com/vital-assets/fitbit.png"
            },
            "created_on": "2022-06-15T13:44:34.770879+00:00"
        },
        {
            "source": {
                "name": null,
                "slug": null,
                "logo": null
            },
            "created_on": "2022-03-01T12:25:15.558385+00:00"
        },
        {
            "source": null,
            "created_on": null
        }
    ]
}
''';

const fakeRefreshResponse = '''
{
    "success": true,
    "user_id": "user_id_1",
    "refreshed_sources": [
        "Freestyle Libre/vitals/glucose",
        "Garmin/body",
        "Garmin/activity",
        "Garmin/workouts",
        "Garmin/sleep"
    ],
    "failed_sources": [
        "Fitbit/heartrate",
        "Fitbit/body",
        "Fitbit/activity"
    ]
}
''';

const fakeProvidersResponse = '''{
    "providers": [
        {
            "name": "Fitbit",
            "slug": "fitbit",
            "logo": "https://storage.googleapis.com/vital-assets/fitbit.png"
        },
        {
        }
    ]
}''';

const fakeCreateUserResponse =
    '''{"user_id":"user_id_1","user_key":"user_key_1","client_user_id":"Test 1"}''';
const fakeDeleteUserResponse = '''{"success":true}''';
const fakeDeregisterProviderResponse = '''{"success":true}''';
