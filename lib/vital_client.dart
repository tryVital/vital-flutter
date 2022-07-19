import 'package:vital_flutter/services/activity_service.dart';
import 'package:vital_flutter/services/body_service.dart';
import 'package:vital_flutter/services/link_service.dart';
import 'package:vital_flutter/services/profile_service.dart';
import 'package:vital_flutter/services/sleep_service.dart';
import 'package:vital_flutter/services/testkits_service.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/services/vitals_service.dart';
import 'package:vital_flutter/services/workout_service.dart';

import 'environment.dart';
import 'region.dart';

class VitalClient {
  late final String _baseUrl;
  late final String _apiKey;

  late final activityService = ActivityService.create(_baseUrl, _apiKey);
  late final bodyService = BodyService.create(_baseUrl, _apiKey);
  late final linkService = LinkService.create(_baseUrl, _apiKey);
  late final profileService = ProfileService.create(_baseUrl, _apiKey);
  late final sleepService = SleepService.create(_baseUrl, _apiKey);
  late final testkitsService = TestkitsService.create(_baseUrl, _apiKey);
  late final userService = UserService.create(_baseUrl, _apiKey);
  late final vitalsService = VitalsService.create(_baseUrl, _apiKey);
  late final workoutService = WorkoutService.create(_baseUrl, _apiKey);

  init({
    required Region region,
    required Environment environment,
    required String apiKey,
  }) {
    _baseUrl = _resolveUrl(region, environment);
    _apiKey = apiKey;
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
}
