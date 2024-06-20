// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$SleepService extends SleepService {
  _$SleepService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SleepService;

  @override
  Future<Response<SleepResponse>> _getSleepData(
    String userId,
    String startDate,
    String? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/sleep/${userId}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SleepResponse, SleepResponse>($request);
  }

  @override
  Future<Response<Object>> _getSleepDataRaw(
    String userId,
    String startDate,
    String? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/sleep/${userId}/raw');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }
}
