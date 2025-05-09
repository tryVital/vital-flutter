// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ActivityService extends ActivityService {
  _$ActivityService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ActivityService;

  @override
  Future<Response<ActivitiesResponse>> _getActivity(
    String userId,
    String startDate,
    String? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/activity/${userId}');
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
    return client.send<ActivitiesResponse, ActivitiesResponse>(
      $request,
      requestConverter: JsonConverter.requestFactory,
    );
  }

  @override
  Future<Response<Object>> getActivityRaw(
    String userId,
    DateTime startDate,
    DateTime? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('summary/activity/${userId}/raw');
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
