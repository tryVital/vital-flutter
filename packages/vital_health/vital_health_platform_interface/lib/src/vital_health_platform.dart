import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vital_core/vital_core.dart';
import 'package:vital_health_platform_interface/src/data/permission_outcome.dart';
import 'package:vital_health_platform_interface/src/data/sync_data.dart';
import 'package:vital_health_platform_interface/src/healthkit_resource.dart';

class VitalHealthPlatform extends PlatformInterface {
  static final Object _token = Object();

  VitalHealthPlatform() : super(token: _token);

  static VitalHealthPlatform _instance = VitalHealthPlatform();

  static set instance(VitalHealthPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  static VitalHealthPlatform get instance => _instance;

  Stream<SyncStatus> get status =>
      throw UnimplementedError('status() has not been implemented.');

  Future<void> configureClient(
          String apiKey, Region region, Environment environment) =>
      throw UnimplementedError('configureClient() has not been implemented.');

  Future<void> configureHealthkit({
    bool backgroundDeliveryEnabled = false,
    bool logsEnabled = true,
    int numberOfDaysToBackFill = 90,
    String dataPushMode = "automatic",
  }) =>
      throw UnimplementedError(
          'configureHealthkit() has not been implemented.');

  Future<void> setUserId(String userId) =>
      throw UnimplementedError('setUserId() has not been implemented.');

  Future<PermissionOutcome> askForResources(
          List<HealthkitResource> resources) =>
      throw UnimplementedError('askForResources() has not been implemented.');

  Future<PermissionOutcome> ask(List<HealthkitResource> readResources,
      List<HealthkitResourceWrite> writeResources) async {
    throw UnimplementedError('ask() has not been implemented.');
  }

  Future<bool> hasAskedForPermission(HealthkitResource resource) =>
      throw UnimplementedError(
          'hasAskedForPermission() has not been implemented.');

  Future<void> syncData({List<HealthkitResource>? resources}) =>
      throw UnimplementedError('syncData() has not been implemented.');

  Future<void> cleanUp() =>
      throw UnimplementedError('cleanUp() has not been implemented.');

  Future<bool> isUserConnected(String provider) {
    throw UnimplementedError('isUserConnected() has not been implemented.');
  }

  writeHealthKitData(HealthkitResourceWrite writeResource, DateTime startDate,
      DateTime endDate, double value) {
    throw UnimplementedError('writeHealthKitData() has not been implemented.');
  }
}
