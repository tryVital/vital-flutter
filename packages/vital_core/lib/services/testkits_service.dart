library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_core/services/data/testkits.dart';
import 'package:vital_core/services/utils/http_api_key_interceptor.dart';
import 'package:vital_core/services/utils/http_logging_interceptor.dart';
import 'package:vital_core/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'testkits_service.chopper.dart';

@ChopperApi()
abstract class TestkitsService extends ChopperService {
  @Post(path: 'testkit/orders')
  Future<Response<OrderResponse>> _createOrder(
    @Body() CreateOrderRequest request, {
    @Header('skip-address-validation') String skipAddressValidation = 'false',
  });

  Future<Response<OrderResponse>> createOrder(
    CreateOrderRequest request, {
    bool skipAddressValidation = false,
  }) {
    return _createOrder(request,
        skipAddressValidation: '$skipAddressValidation');
  }

  @Get(path: 'testkit/')
  Future<Response<TestkitsResponse>> getAllTestkits();

  @Get(path: 'testkit/orders/{order_id}')
  @Deprecated('For backwards compatibility, use getOrder')
  Future<Response<OrderData>> getOrderStatus(@Path('order_id') String orderId);

  @Get(path: 'testkit/orders/{order_id}')
  Future<Response<OrderData>> getOrder(@Path('order_id') String orderId);

  @Get(path: 'testkit/orders')
  Future<Response<OrdersResponse>> _getAllOrders(
    @Query('start_date') String startDate,
    @Query('end_date') String endDate,
    @Query('status') List<String>? status, {
    @Query('page') int page = 1,
    @Query('size') int size = 50,
  });

  Future<Response<OrdersResponse>> getAllOrders(
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime endDate,
    @Query('status') List<String>? status, {
    int page = 1,
    int size = 50,
  }) {
    return _getAllOrders(
      startDate.toIso8601String(),
      endDate.toIso8601String(),
      status,
      page: page,
      size: size,
    );
  }

  @Post(path: 'testkit/orders/{order_id}/cancel', optionalBody: true)
  Future<Response<OrderResponse>> cancelOrder(@Path('order_id') String orderId);

  static TestkitsService create(
      http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
        client: httpClient,
        baseUrl: baseUrl,
        interceptors: [
          HttpRequestLoggingInterceptor(),
          HttpApiKeyInterceptor(apiKey)
        ],
        converter: const JsonSerializableConverter({
          OrdersResponse: OrdersResponse.fromJson,
          TestkitsResponse: TestkitsResponse.fromJson,
          OrderResponse: OrderResponse.fromJson,
          OrderData: OrderData.fromJson,
        }));

    return _$TestkitsService(client);
  }
}
