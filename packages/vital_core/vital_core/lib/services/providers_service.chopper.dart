// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProvidersService extends ProvidersService {
  _$ProvidersService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProvidersService;

  @override
  Future<Response<List<AvailableProvider>>> get() {
    final Uri $url = Uri.parse('providers');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<AvailableProvider>, AvailableProvider>($request);
  }
}
