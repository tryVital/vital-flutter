// GENERATED CODE - DO NOT MODIFY BY HAND

part of vital;

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$DevicesService extends DevicesService {
  _$DevicesService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DevicesService;

  @override
  Future<Response<DevicesResponse>> getDevicesData(
      String userId, String? provider) {
    final $url = '/summary/devices/${userId}/raw';
    final $params = <String, dynamic>{'provider': provider};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DevicesResponse, DevicesResponse>($request);
  }
}
