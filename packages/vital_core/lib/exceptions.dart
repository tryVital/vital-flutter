abstract class VitalException implements Exception {
  final String code;
  final String message;

  VitalException(this.code, this.message);
}

class UnsupportedRegionException extends VitalException {
  UnsupportedRegionException(String message)
      : super('UnsupportedRegion', message);

  @override
  String toString() {
    return 'UnsupportedRegionException{ code: $code, message: $message }';
  }
}

class ClientSetupException extends VitalException {
  ClientSetupException(String message) : super('ClientSetupException', message);

  @override
  String toString() {
    return 'UnsupportedRegionException{ code: $code, message: $message }';
  }
}

class UnsupportedEnvironmentException extends VitalException {
  UnsupportedEnvironmentException(String message)
      : super('UnsupportedEnvironment', message);

  @override
  String toString() {
    return 'UnsupportedEnvironmentException{ code: $code, message: $message }';
  }
}

class UnsupportedResourceException extends VitalException {
  UnsupportedResourceException(String message)
      : super('UnsupportedResource', message);

  @override
  String toString() {
    return 'UnsupportedResourceException{ code: $code, message: $message }';
  }
}

class UnsupportedProviderException extends VitalException {
  UnsupportedProviderException(String message)
      : super('UnsupportedProvider', message);

  @override
  String toString() {
    return 'UnsupportedProviderException{ code: $code, message: $message }';
  }
}

class UnknownException extends VitalException {
  UnknownException(String message) : super("UnknownException", message);

  @override
  String toString() {
    return 'UnknownException{ code: $code, message: $message }';
  }
}

class VitalHTTPStatusException extends VitalException {
  VitalHTTPStatusException(int code, String message)
      : super("VitalHTTPStatusException", message);

  @override
  String toString() {
    return 'VitalHTTPStatusException{ code: $code, message: $message }';
  }
}
