import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vital_health_platform_interface/vital_health_platform_interface.dart';

class VitalHealthPlatform extends PlatformInterface {
  static final Object _token = Object();

  VitalHealthPlatform() : super(token: _token);

  static VitalHealthPlatform Function()? _instanceFactory = null;
  static VitalHealthPlatform? _instance;

  static set instanceFactory(VitalHealthPlatform Function() factory) {
    _instanceFactory = factory;
  }

  static VitalHealthPlatform get instance {
    if (_instance == null) {
      _instance = _instanceFactory!();
      PlatformInterface.verify(_instance!, _token);
    }
    return _instance!;
  }

  Stream<SyncStatus> get status =>
      throw UnimplementedError('status() has not been implemented.');

  Stream<ConnectionStatus> connectionStatus() =>
      throw UnimplementedError('connectionStatus() has not been implemented.');

  Future<bool> isAvailable() =>
      throw UnimplementedError('isAvailable() has not been implemented.');

  Future<void> configureHealth({required HealthConfig config}) =>
      throw UnimplementedError('configureHealth() has not been implemented.');

  Future<PermissionOutcome> ask(List<HealthResource> readResources,
      List<HealthResourceWrite> writeResources) async {
    throw UnimplementedError('ask() has not been implemented.');
  }

  Future<bool> hasAskedForPermission(HealthResource resource) =>
      throw UnimplementedError(
          'hasAskedForPermission() has not been implemented.');

  Future<Map<HealthResource, PermissionStatus>> permissionStatus(
          List<HealthResource> resources) =>
      throw UnimplementedError('permissionStatus() has not been implemented.');

  Future<void> syncData({List<HealthResource>? resources}) =>
      throw UnimplementedError('syncData() has not been implemented.');

  Future<void> writeHealthData(HealthResourceWrite writeResource,
      DateTime startDate, DateTime endDate, double value) {
    throw UnimplementedError('writeHealthData() has not been implemented.');
  }

  Future<ProcessedData?> read(
      HealthResource resource, DateTime startDate, DateTime endDate) {
    throw UnimplementedError('read() has not been implemented.');
  }

  Future<bool> getPauseSynchronization() {
    throw UnimplementedError();
  }

  Future<void> setPauseSynchronization(bool paused) {
    throw UnimplementedError();
  }

  Future<bool> isBackgroundSyncEnabled() {
    throw UnimplementedError();
  }

  Future<bool> enableBackgroundSync() {
    throw UnimplementedError();
  }

  Future<void> disableBackgroundSync() {
    throw UnimplementedError();
  }

  Future<void> setSyncNotificationContent(SyncNotificationContent content) {
    throw UnimplementedError();
  }

  Future<void> openSyncProgressView() {
    throw UnimplementedError();
  }

  Future<ConnectionStatus> getConnectionStatus() {
    throw UnimplementedError();
  }

  Future<void> connect() {
    throw UnimplementedError();
  }

  Future<void> disconnect() {
    throw UnimplementedError();
  }
}
