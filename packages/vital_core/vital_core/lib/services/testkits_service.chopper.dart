// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testkits_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$TestkitsService extends TestkitsService {
  _$TestkitsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = TestkitsService;

  @override
  Future<Response<OrderResponse>> _createOrder(
    CreateOrderRequest request, {
    String skipAddressValidation = 'false',
  }) {
    final Uri $url = Uri.parse('testkit/orders');
    final Map<String, String> $headers = {
      'skip-address-validation': skipAddressValidation,
    };
    final $body = request;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<OrderResponse, OrderResponse>($request);
  }

  @override
  Future<Response<TestkitsResponse>> getAllTestkits() {
    final Uri $url = Uri.parse('testkit/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<TestkitsResponse, TestkitsResponse>($request);
  }

  @override
  Future<Response<OrderData>> getOrderStatus(String orderId) {
    final Uri $url = Uri.parse('testkit/orders/${orderId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<OrderData, OrderData>($request);
  }

  @override
  Future<Response<OrderData>> getOrder(String orderId) {
    final Uri $url = Uri.parse('testkit/orders/${orderId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<OrderData, OrderData>($request);
  }

  @override
  Future<Response<OrdersResponse>> _getAllOrders(
    String startDate,
    String endDate,
    List<String>? status, {
    int page = 1,
    int size = 50,
  }) {
    final Uri $url = Uri.parse('testkit/orders');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'page': page,
      'size': size,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<OrdersResponse, OrdersResponse>($request);
  }

  @override
  Future<Response<OrderResponse>> cancelOrder(String orderId) {
    final Uri $url = Uri.parse('testkit/orders/${orderId}/cancel');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<OrderResponse, OrderResponse>($request);
  }
}
