import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vital_client/services/data/testkits.dart';
import 'package:vital_client/services/testkits_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {});

  tearDown(() {});

  group('Testkits service', () {
    test('Get all orders', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/testkit/orders'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        expect(req.url.queryParameters['start_date'], startsWith('2022-07-01'));
        expect(req.url.queryParameters['end_date'], startsWith('2022-07-21'));
        return http.Response(
          fakeOrdersResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = TestkitsService.create(httpClient, '', apiKey);
      final response = await sut.getAllOrders(DateTime.parse('2022-07-01'), DateTime.parse('2022-07-21'), null);

      expect(response.body!.orders.length, 1);
      final order = response.body!.orders[0];
      checkOrder(order);
    });

    test('Get all testkits', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), startsWith('/testkit/'));
        expect(req.method, 'GET');
        expect(req.headers['x-vital-api-key'], apiKey);
        return http.Response(
          fakeTestKitsResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = TestkitsService.create(httpClient, '', apiKey);
      final response = await sut.getAllTestkits();

      expect(response.body!.testkits.length, 2);
      final testkit1 = response.body!.testkits[0];
      expect(testkit1.id, '71d54fff-70e1-4f74-937e-5a185b925d0d');
      expect(testkit1.markers.length, 2);
      expect(testkit1.markers[0].name, 'ALLERGEN-Blomia tropicalis');
      expect(testkit1.markers[0].slug, 'ag:blomia_tropicalis');
      expect(testkit1.markers[0].description, null);
    });

    test('Create order', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), '/testkit/orders');
        expect(req.method, 'POST');
        expect(req.headers['x-vital-api-key'], apiKey);
        final request = CreateOrderRequest.fromJson(json.decode(req.body));
        expect(request.userId, userId);
        expect(request.testkitId, '71d54fff-70e1-4f74-937e-5a185b925d0d');
        expect(request.patientAddress.receiverName, 'Receiver Name');
        expect(request.patientDetails.gender, 'male');

        return http.Response(
          fakeCreateResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = TestkitsService.create(httpClient, '', apiKey);
      final response = await sut.createOrder(
          CreateOrderRequest(
            testkitId: '71d54fff-70e1-4f74-937e-5a185b925d0d',
            userId: userId,
            patientAddress: PatientAddress(
                receiverName: "Receiver Name",
                street: "340 street",
                streetNumber: "340",
                city: "City",
                state: "State",
                zip: "12345",
                country: "US",
                phoneNumber: "+123"),
            patientDetails: PatientDetails(
              dob: DateTime(1993, 8, 18),
              gender: 'male',
            ),
          ),
          skipAddressValidation: true);

      expect(response.body!.status, 'success');
      expect(response.body!.message, 'order created');
      final order = response.body!.order!;
      checkOrder(order);
    });

    test('Cancel order', () async {
      final httpClient = MockClient((http.Request req) async {
        expect(req.url.toString(), '/testkit/orders/id_1/cancel');
        expect(req.method, 'POST');
        expect(req.headers['x-vital-api-key'], apiKey);

        return http.Response(
          fakeCancelResponse,
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final sut = TestkitsService.create(httpClient, '', apiKey);
      final response = await sut.cancelOrder('id_1');

      expect(response.body!.status, 'success');
      expect(response.body!.message, 'order cancelled');
      final order = response.body!.order!;
      checkOrder(order, status: 'cancelled');
    });
  });
}

void checkOrder(OrderData order, {String status = 'ordered'}) {
  expect(order.id, 'id_1');
  expect(order.userId, userId);
  expect(order.testkit!.id, '71d54fff-70e1-4f74-937e-5a185b925d0d');
  expect(order.patientAddress!.receiverName, 'Receiver Name');
  expect(order.patientDetails!.gender, 'male');
  expect(order.status, status);
}

const userId = 'user_id_1';
const apiKey = 'API_KEY';

const fakeTestKitsResponse = '''{
    "testkits": [
        {
            "id": "71d54fff-70e1-4f74-937e-5a185b925d0d",
            "name": "Respiratory Allergen",
            "description": "Respiratory Allergens ",
            "markers": [
                {
                    "name": "ALLERGEN-Blomia tropicalis",
                    "slug": "ag:blomia_tropicalis",
                    "description": null
                },
                {
                    "name": "ALLERGEN-D. pteronyssinus",
                    "slug": "ag:d._pteronyssinus",
                    "description": null
                }
            ],
            "turnaround_time_lower": 4,
            "turnaround_time_upper": 14,
            "price": 250.0
        },
        {
            "id": "8ac4e01b-95a2-4bcf-a6f3-4cccacb74821",
            "name": "Wyndly Respiratory Allergen",
            "description": "Respiratory Allergens",
            "markers": [
                {
                    "name": "ALLERGEN-Blomia tropicalis",
                    "slug": "ag:blomia_tropicalis",
                    "description": null
                }
            ],
            "turnaround_time_lower": 4,
            "turnaround_time_upper": 14,
            "price": 270.0
        }
    ]
    }''';

const fakeOrdersResponse = '''{
    "orders": [
        {
            "user_id": "user_id_1",
            "user_key": "user_key_1",
            "id": "id_1",
            "team_id": "team_id_1",
            "created_on": "2022-07-05T15:14:41.547806+00:00",
            "updated_on": "2022-07-05T15:14:41.547806+00:00",
            "status": "ordered",
            "testkit_id": "testkit_id_1",
            "testkit": {
                "id": "71d54fff-70e1-4f74-937e-5a185b925d0d",
                "name": "Respiratory Allergen",
                "description": "Respiratory Allergens ",
                "markers": [],
                "turnaround_time_lower": 4,
                "turnaround_time_upper": 14,
                "price": 250.0
            },
            "inbound_tracking_number": null,
            "outbound_tracking_number": null,
            "inbound_tracking_url": null,
            "outbound_tracking_url": null,
            "outbound_courier": null,
            "inbound_courier": null,
            "patient_address": {
                "receiver_name": "Receiver Name",
                "street": "340 street",
                "street_number": "340",
                "city": "City",
                "state": "State",
                "zip": "12345",
                "country": "US",
                "phone_number": "+123"
            },
            "patient_details": {
                "dob": "1993-08-18T00:00:00+00:00",
                "gender": "male",
                "email": null
            },
            "sample_id": null
        }
    ],
    "total": 1,
    "page": 1,
    "size": 50
    }''';

const fakeCreateResponse = '''{
    "order": {
        "user_id": "user_id_1",
        "user_key": "user_key_1",
        "id": "id_1",
        "team_id": "team_id_1",
        "created_on": "2022-07-05T15:14:41.547806+00:00",
        "updated_on": "2022-07-05T15:14:41.547806+00:00",
        "status": "ordered",
        "testkit_id": "testkit_id_1",
        "testkit": {
            "id": "71d54fff-70e1-4f74-937e-5a185b925d0d",
            "name": "Respiratory Allergen",
            "description": "Respiratory Allergens ",
            "markers": [],
            "turnaround_time_lower": 4,
            "turnaround_time_upper": 14,
            "price": 250.0
        },
        "inbound_tracking_number": null,
        "outbound_tracking_number": null,
        "inbound_tracking_url": null,
        "outbound_tracking_url": null,
        "outbound_courier": null,
        "inbound_courier": null,
        "patient_address": {
            "receiver_name": "Receiver Name",
            "street": "340 street",
            "street_number": "340",
            "city": "City",
            "state": "State",
            "zip": "12345",
            "country": "US",
            "phone_number": "+123"
        },
        "patient_details": {
            "dob": "1993-08-18T00:00:00+00:00",
            "gender": "male",
            "email": null
        },
        "sample_id": null
    },
    "status": "success",
    "message": "order created"
    }''';

const fakeCancelResponse = '''{
    "order": {
        "user_id": "user_id_1",
        "user_key": "user_key_1",
        "id": "id_1",
        "team_id": "team_id_1",
        "created_on": "2022-07-05T15:14:41.547806+00:00",
        "updated_on": "2022-07-05T15:14:41.547806+00:00",
        "status": "cancelled",
        "testkit_id": "testkit_id_1",
        "testkit": {
            "id": "71d54fff-70e1-4f74-937e-5a185b925d0d",
            "name": "Respiratory Allergen",
            "description": "Respiratory Allergens ",
            "markers": [],
            "turnaround_time_lower": 4,
            "turnaround_time_upper": 14,
            "price": 250.0
        },
        "inbound_tracking_number": null,
        "outbound_tracking_number": null,
        "inbound_tracking_url": null,
        "outbound_tracking_url": null,
        "outbound_courier": null,
        "inbound_courier": null,
        "patient_address": {
            "receiver_name": "Receiver Name",
            "street": "340 street",
            "street_number": "340",
            "city": "City",
            "state": "State",
            "zip": "12345",
            "country": "US",
            "phone_number": "+123"
        },
        "patient_details": {
            "dob": "1993-08-18T00:00:00+00:00",
            "gender": "male",
            "email": null
        },
        "sample_id": null
    },
    "status": "success",
    "message": "order cancelled"
    }''';

const fakeOrderData = '''{
        "user_id": "user_id_1",
        "user_key": "user_key_1",
        "id": "id_1",
        "team_id": "team_id_1",
        "created_on": "2022-07-05T15:14:41.547806+00:00",
        "updated_on": "2022-07-05T15:14:41.547806+00:00",
        "status": "ordered",
        "testkit_id": "testkit_id_1",
        "testkit": {
            "id": "71d54fff-70e1-4f74-937e-5a185b925d0d",
            "name": "Respiratory Allergen",
            "description": "Respiratory Allergens ",
            "markers": [],
            "turnaround_time_lower": 4,
            "turnaround_time_upper": 14,
            "price": 250.0
        },
        "inbound_tracking_number": null,
        "outbound_tracking_number": null,
        "inbound_tracking_url": null,
        "outbound_tracking_url": null,
        "outbound_courier": null,
        "inbound_courier": null,
        "patient_address": {
            "receiver_name": "Receiver Name",
            "street": "340 street",
            "street_number": "340",
            "city": "City",
            "state": "State",
            "zip": "12345",
            "country": "US",
            "phone_number": "+123"
        },
        "patient_details": {
            "dob": "1993-08-18T00:00:00+00:00",
            "gender": "male",
            "email": null
        },
        "sample_id": null
    }''';
