import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vital_flutter/platform/healthkit_services.dart';
import 'package:vital_flutter/vital_flutter.dart';
import 'package:vital_flutter/services/activity_service.dart';
import 'package:vital_flutter/services/body_service.dart';
import 'package:vital_flutter/services/data/user.dart';
import 'package:vital_flutter/services/link_service.dart';
import 'package:vital_flutter/services/profile_service.dart';
import 'package:vital_flutter/services/sleep_service.dart';
import 'package:vital_flutter/services/testkits_service.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/services/vitals_service.dart';
import 'package:vital_flutter/services/workout_service.dart';
import 'package:http/http.dart' as http;

import 'environment.dart';
import 'region.dart';

class VitalClient {
  late final http.Client _httpClient;
  late final String _baseUrl;
  late final String _apiKey;
  late final Region _region;
  late final Environment _environment;

  late final activityService = ActivityService.create(_httpClient, _baseUrl, _apiKey);
  late final bodyService = BodyService.create(_httpClient, _baseUrl, _apiKey);
  late final linkService = LinkService.create(_httpClient, _baseUrl, _apiKey);
  late final profileService = ProfileService.create(_httpClient, _baseUrl, _apiKey);
  late final sleepService = SleepService.create(_httpClient, _baseUrl, _apiKey);
  late final testkitsService = TestkitsService.create(_httpClient, _baseUrl, _apiKey);
  late final userService = UserService.create(_httpClient, _baseUrl, _apiKey);
  late final vitalsService = VitalsService.create(_httpClient, _baseUrl, _apiKey);
  late final workoutService = WorkoutService.create(_httpClient, _baseUrl, _apiKey);

  static const MethodChannel _channel = MethodChannel('vital_flutter');

  late final healthkitServices = HealthkitServices(
    _channel,
    apiKey: _apiKey,
    region: _region,
    environment: _environment,
  );

  init({
    required Region region,
    required Environment environment,
    required String apiKey,
  }) {
    _httpClient = http.Client();
    _baseUrl = _resolveUrl(region, environment);
    _apiKey = apiKey;
    _region = region;
    _environment = environment;
  }

  String _resolveUrl(Region region, Environment environment) {
    final urls = {
      Region.eu: {
        Environment.production: 'https://api.eu.tryvital.io',
        Environment.dev: 'https://api.dev.eu.tryvital.io',
        Environment.sandbox: 'https://api.sandbox.eu.tryvital.io',
      },
      Region.us: {
        Environment.production: 'https://api.tryvital.io',
        Environment.dev: 'https://api.dev.tryvital.io',
        Environment.sandbox: 'https://api.sandbox.tryvital.io',
      }
    };
    return '${urls[region]![environment]!}/v2';
  }

  Future<bool> linkProvider(User user, String provider, String callback) {
    return linkService
        .createLink(user.userId!, provider, callback)
        .then((tokenResponse) => linkService.oauthProvider(
              provider: provider,
              linkToken: tokenResponse.body!.linkToken!,
            ))
        .then((oauthResponse) => launchUrlString(oauthResponse.body!.oauthUrl!, mode: LaunchMode.externalApplication))
        .catchError((e) {
      Fimber.e(e);
      return false;
    });
  }
}
