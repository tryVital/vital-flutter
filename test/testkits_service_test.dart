import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vital_flutter/environment.dart';
import 'package:vital_flutter/region.dart';
import 'package:vital_flutter/services/data/testkits.dart';
import 'package:vital_flutter/services/testkits_service.dart';
import 'package:vital_flutter/services/user_service.dart';
import 'package:vital_flutter/vital_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    HttpOverrides.global = _MyHttpOverrides();
  });

  tearDown(() {});

  test('Testkits service', () async {
    //const apiKey = 'sk_eu_HCgKZT1Icv0Oyw8mmpyPu6E2NuD-bnmeFFeg43k2hgw';
    const apiKey = 'sk_us_309IjVjh-vSuDw-DM_06k3b3N2NzuItWYmQ9pRhLDV0';
    final VitalClient client = VitalClient()
      ..init(
        region: Region.us,
        environment: Environment.sandbox,
        apiKey: apiKey,
      );
    final UserService userService = client.userService;
    final TestkitsService testkitService = client.testkitsService;

    final users = await userService.getAll();

    final orders = await testkitService.getAllOrders(
      DateTime.parse('2022-07-01'),
      DateTime.now(),
      null,
    );
    print(orders);

    final testkits = await testkitService.getAllTestkits();
    print(testkits);

    final create = await testkitService.createOrder(
      CreateOrderRequest(
        testkitId: testkits.body!.testkits[0].id,
        userId: users.body![0].userId!,
        patientAddress: PatientAddress(
          receiverName: 'Jan',
          street: '12 Chapman house',
          city: 'London',
          country: 'United Kingdom',
          state: 'England',
          zip: 'W5 5EF',
          phoneNumber: '+447470062567',
        ),
        patientDetails: PatientDetails(
          dob: DateTime(1980, 1, 1),
          gender: 'male',
        ),
      ),
      skipAddressValidation: true,
    );
    print(create);

    final cancel = await testkitService.cancelOrder(create.body!.order!.id!);
    print(cancel);

    await testkitService.getAllOrders(
      DateTime.parse('2022-07-01'),
      DateTime.now(),
      null,
    );
  });
}

class _MyHttpOverrides extends HttpOverrides {}
