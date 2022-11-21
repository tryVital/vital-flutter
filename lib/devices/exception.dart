abstract class DeviceManagerExceptions implements Exception {
  final String code;
  final String message;

  DeviceManagerExceptions(this.code, this.message);
}

class UnsupportedRegionException extends DeviceManagerExceptions {
  UnsupportedRegionException(String message)
      : super('UnsupportedRegion', message);

  @override
  String toString() {
    return 'UnsupportedRegionException{ code: $code, message: $message }';
  }
}

class UnsupportedEnvironmentException extends DeviceManagerExceptions {
  UnsupportedEnvironmentException(String message)
      : super('UnsupportedEnvironment', message);

  @override
  String toString() {
    return 'UnsupportedEnvironmentException{ code: $code, message: $message }';
  }
}

class UnsupportedResourceException extends DeviceManagerExceptions {
  UnsupportedResourceException(String message)
      : super('UnsupportedResource', message);

  @override
  String toString() {
    return 'UnsupportedResourceException{ code: $code, message: $message }';
  }
}

class UnsupportedBrandException extends DeviceManagerExceptions {
  UnsupportedBrandException(String message)
      : super('UnsupportedBrand', message);

  @override
  String toString() {
    return 'UnsupportedBrandException{ code: $code, message: $message }';
  }
}

class UnsupportedKindException extends DeviceManagerExceptions {
  UnsupportedKindException(String message) : super('UnsupportedKind', message);

  @override
  String toString() {
    return 'UnsupportedKindException{ code: $code, message: $message }';
  }
}

class PairErrorException extends DeviceManagerExceptions {
  PairErrorException(String message) : super('PairError', message);

  @override
  String toString() {
    return 'PairErrorException{ code: $code, message: $message }';
  }
}

class UnknownException extends DeviceManagerExceptions {
  UnknownException(String message) : super("UnknownException", message);

  @override
  String toString() {
    return 'UnknownException{ code: $code, message: $message }';
  }
}

class MissingPermissionException extends DeviceManagerExceptions {
  MissingPermissionException(String message)
      : super('MissingPermission', message);

  @override
  String toString() {
    return 'MissingPermissionException{ code: $code, message: $message }';
  }
}

class DeviceNotFoundException extends DeviceManagerExceptions {
  DeviceNotFoundException(String message) : super('DeviceNotFound', message);

  @override
  String toString() {
    return 'DeviceNotFoundException{ code: $code, message: $message }';
  }
}
