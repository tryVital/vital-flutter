import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vital_core_platform_interface/src/vital_core_method_channel.dart';

class VitalCorePlatform extends PlatformInterface {
  static final Object _token = Object();

  VitalCorePlatform() : super(token: _token);

  static VitalCorePlatform _instance = VitalCoreMethodChannel();

  static set instance(VitalCorePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  static VitalCorePlatform get instance => _instance;

  Future<List<String>> clientStatus() {
    throw UnimplementedError();
  }

  Stream<void> clientStatusChanged() => throw UnimplementedError();

  Future<String?> currentUserId() {
    throw UnimplementedError();
  }

  Future<void> setUserId(String userId) {
    throw UnimplementedError();
  }

  Future<void> configure(String apiKey, String environment, String region) {
    throw UnimplementedError();
  }

  Future<void> signIn(String signInToken) {
    throw UnimplementedError();
  }

  Future<bool> hasUserConnectedTo(String provider) {
    throw UnimplementedError();
  }

  Future<String> userConnections() {
    throw UnimplementedError();
  }

  Future<void> deregisterProvider(String provider) {
    throw UnimplementedError();
  }

  Future<void> signOut() {
    throw UnimplementedError();
  }

  Future<String> getAccessToken() {
    throw UnimplementedError();
  }

  Future<void> refreshToken() {
    throw UnimplementedError();
  }

  Future<String> sdkVersion() {
    throw UnimplementedError();
  }

  Future<String> systemTimeZoneName() {
    throw UnimplementedError();
  }
}
