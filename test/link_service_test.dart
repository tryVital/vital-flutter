import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/region.dart';
import 'package:vital_flutter/services/link_service.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/vital_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = _MyHttpOverrides();
  });

  tearDown(() {});

  test('Link service', () async {
    //const apiKey = 'sk_eu_HCgKZT1Icv0Oyw8mmpyPu6E2NuD-bnmeFFeg43k2hgw';
    const apiKey = 'sk_us_309IjVjh-vSuDw-DM_06k3b3N2NzuItWYmQ9pRhLDV0';
    final VitalClient client = VitalClient()
      ..init(
        region: Region.us,
        environment: Environment.sandbox,
        apiKey: apiKey,
      );
    final UserService userService = client.userService;
    final LinkService linkService = client.linkService;

    final users = await userService.getAll();
    final link = await linkService.createLink(users.body![0].userId!, 'strava', 'callback://strava');
    print(link);
    final oauth = await linkService.oauthProvider('strava', link.body!.linkToken!);
    print(oauth);

    final link2 = await linkService.createLink(users.body![0].userId!, 'freestyle_libre', 'callback://freestyle');
    print(link2);
    final email = await linkService.emailProvider(
      'freestyle_libre',
      'jan.knotek@gmail.com',
      Region.us,
      link2.body!.linkToken!,
    );
    print(email);

    final link3 = await linkService.createLink(users.body![0].userId!, 'renpho', 'callback://renpho');
    print(link3);
    final password = await linkService.passwordProvider(
      'renpho',
      'jan.knotek@gmail.com',
      'testrenpho12',
      'callback://renpho',
      link2.body!.linkToken!,
    );
    print(password);
  });
}

class _MyHttpOverrides extends HttpOverrides {}
