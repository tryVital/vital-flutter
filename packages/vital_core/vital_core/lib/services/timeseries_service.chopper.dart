// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeseries_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: type=lint
final class _$TimeseriesService extends TimeseriesService {
  _$TimeseriesService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = TimeseriesService;

  @override
  Future<Response<GroupedIntervalTimeseriesResponse>>
      _intervalTimeseriesRequest(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
    String? nextCursor,
  }) {
    final Uri $url = Uri.parse('timeseries/${userId}/${resource}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
      'next_cursor': nextCursor,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GroupedIntervalTimeseriesResponse,
        GroupedIntervalTimeseriesResponse>($request);
  }

  @override
  Future<Response<GroupedScalarTimeseriesResponse>> _scalarTimeseriesRequest(
    String userId,
    String resource,
    String startDate, {
    String? endDate,
    String? provider,
    String? nextCursor,
  }) {
    final Uri $url = Uri.parse('timeseries/${userId}/${resource}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
      'next_cursor': nextCursor,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GroupedScalarTimeseriesResponse,
        GroupedScalarTimeseriesResponse>($request);
  }

  @override
  Future<Response<GroupedBloodPressureTimeseriesResponse>>
      _bloodPressureTimeseriesRequest(
    String userId,
    String startDate, {
    String? endDate,
    String? provider,
    String? nextCursor,
  }) {
    final Uri $url = Uri.parse('timeseries/${userId}/blood_pressure');
    final Map<String, dynamic> $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider,
      'next_cursor': nextCursor,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GroupedBloodPressureTimeseriesResponse,
        GroupedBloodPressureTimeseriesResponse>($request);
  }
}
