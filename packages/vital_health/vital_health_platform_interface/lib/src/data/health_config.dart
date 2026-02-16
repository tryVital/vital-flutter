enum ConnectionPolicy {
  autoConnect,
  explicit,
}

enum ConnectionStatus {
  autoConnect,
  connected,
  disconnected,
  connectionPaused,
}

class HealthConfig {
  final bool logsEnabled;
  final int numberOfDaysToBackFill;
  final ConnectionPolicy connectionPolicy;
  final AndroidHealthConfig androidConfig;
  final IosHealthConfig iosConfig;

  const HealthConfig({
    this.logsEnabled = true,
    this.numberOfDaysToBackFill = 90,
    this.connectionPolicy = ConnectionPolicy.autoConnect,
    this.androidConfig = const AndroidHealthConfig(),
    this.iosConfig = const IosHealthConfig(),
  });

  @override
  String toString() {
    return 'HealthConfig{logsEnabled: $logsEnabled, numberOfDaysToBackFill: $numberOfDaysToBackFill, connectionPolicy: $connectionPolicy, androidConfig: $androidConfig, iosConfig: $iosConfig}';
  }
}

class AndroidHealthConfig {
  final bool syncOnAppStart;

  const AndroidHealthConfig({
    this.syncOnAppStart = true,
  });

  @override
  String toString() {
    return 'AndroidHealthConfig{}';
  }
}

class IosHealthConfig {
  final String dataPushMode;
  final bool backgroundDeliveryEnabled;

  const IosHealthConfig({
    this.dataPushMode = "automatic",
    this.backgroundDeliveryEnabled = false,
  });

  @override
  String toString() {
    return 'IosHealthConfig{dataPushMode: $dataPushMode, backgroundDeliveryEnabled: $backgroundDeliveryEnabled}';
  }
}
