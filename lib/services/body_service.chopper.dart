// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$BodyService extends BodyService {
  _$BodyService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = BodyService;

  @override
  Future<Response<BodyData>> getBodyData(
      String userId, DateTime startDate, DateTime? endDate, String? provider) {
    final $url = '/summary/body/${userId}';
    final $params = <String, dynamic>{
      'start_date': startDate,
      'end_date': endDate,
      'provider': provider
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BodyData, BodyData>($request);
  }
}
