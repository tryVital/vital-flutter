// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BodyService extends BodyService {
  _$BodyService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BodyService;

  @override
  Future<Response<BodyDataResponse>> getBodyData(
    String userId,
    DateTime startDate,
    DateTime? endDate,
    String? provider,
  ) {
    final Uri $url = Uri.parse('/summary/body/${userId}');
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
    return client.send<BodyDataResponse, BodyDataResponse>($request);
  }
}
