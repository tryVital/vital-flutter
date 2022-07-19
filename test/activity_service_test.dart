import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/region.dart';
import 'package:vital_flutter/services/activity_service.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/vital_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = _MyHttpOverrides();
  });

  tearDown(() {});

  test('Activity service', () async {
    //const apiKey = 'sk_eu_HCgKZT1Icv0Oyw8mmpyPu6E2NuD-bnmeFFeg43k2hgw';
    const apiKey = 'sk_us_309IjVjh-vSuDw-DM_06k3b3N2NzuItWYmQ9pRhLDV0';
    final VitalClient client = VitalClient()
      ..init(
        region: Region.us,
        environment: Environment.sandbox,
        apiKey: apiKey,
      );
    final UserService userService = client.userService;
    final ActivityService activityService = client.activityService;

    final users = await userService.getAll();

    final activities = await activityService.getActivity(
      users.body![0].userId!,
      DateTime.parse('2022-07-01'),
      DateTime.now(),
      null,
    );
    print(activities);
  });
}

class _MyHttpOverrides extends HttpOverrides {}
