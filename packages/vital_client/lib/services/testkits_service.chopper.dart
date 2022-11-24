// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$TestkitsService extends TestkitsService {
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
    final $url = 'testkit/orders';
    final $headers = {
      'skip-address-validation': skipAddressValidation,
    };

    final $body = request;
    final $request = Request(
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
    final $url = 'testkit/';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<TestkitsResponse, TestkitsResponse>($request);
  }

  @override
  Future<Response<OrderData>> getOrderStatus(String orderId) {
    final $url = 'testkit/orders/${orderId}';
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<OrderData, OrderData>($request);
  }

  @override
  Future<Response<OrderData>> getOrder(String orderId) {
    final $url = 'testkit/orders/${orderId}';
    final $request = Request(
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
    final $url = 'testkit/orders';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'page': page,
      'size': size,
    };
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<OrdersResponse, OrdersResponse>($request);
  }

  @override
  Future<Response<OrderResponse>> cancelOrder(String orderId) {
    final $url = 'testkit/orders/${orderId}/cancel';
    final $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<OrderResponse, OrderResponse>($request);
  }
}
