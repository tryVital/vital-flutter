import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/region.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/vital_client.dart';
import 'package:vital_flutter/vital_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('vital_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = _MyHttpOverrides();

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await VitalFlutter.platformVersion, '42');
  });

  test('User service', () async {
    const apiKey = 'sk_us_309IjVjh-vSuDw-DM_06k3b3N2NzuItWYmQ9pRhLDV0';

    final VitalClient client = VitalClient()
      ..init(
        region: Region.us,
        environment: Environment.sandbox,
        apiKey: apiKey,
      );
    final UserService userService = client.userService;

    //const apiKey = 'sk_eu_HCgKZT1Icv0Oyw8mmpyPu6E2NuD-bnmeFFeg43k2hgw';

    //print(await userService.createUser("Jan 3"));

    final result = await userService.getAll();
    print(result);
    print("=====\n\n\n");
    final user = await userService.getUser(result.body![0].userId!);
    print(user);
    final userId = user.body!.userId!;

    final response = await userService.refreshUser(userId);

    final providers = await userService.getProviders(userId);

    //final resolve = await userService.resolveUser("Jan 3");

    //final create = await userService.createUser("Jan test 4");
    //print(create);

    //final delete = await userService.deleteUser(create.body!.userId!);

    //print(delete);
    //await userService.deregisterProvider(userId, 'oura');
    /*print(await userService.getAll());*/
  });
}

class _MyHttpOverrides extends HttpOverrides {}
