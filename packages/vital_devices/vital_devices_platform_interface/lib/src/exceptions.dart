import 'package:vital_core/exceptions.dart';

class UnsupportedBrandException extends VitalException {
  UnsupportedBrandException(String message)
      : super('UnsupportedBrand', message);

  @override
  String toString() {
    return 'UnsupportedBrandException{ code: $code, message: $message }';
  }
}

class UnsupportedKindException extends VitalException {
  UnsupportedKindException(String message) : super('UnsupportedKind', message);

  @override
  String toString() {
    return 'UnsupportedKindException{ code: $code, message: $message }';
  }
}

class PairErrorException extends VitalException {
  PairErrorException(String message) : super('PairError', message);

  @override
  String toString() {
    return 'PairErrorException{ code: $code, message: $message }';
  }
}

class MissingPermissionException extends VitalException {
  MissingPermissionException(String message)
      : super('MissingPermission', message);

  @override
  String toString() {
    return 'MissingPermissionException{ code: $code, message: $message }';
  }
}

class DeviceNotFoundException extends VitalException {
  DeviceNotFoundException(String message) : super('DeviceNotFound', message);

  @override
  String toString() {
    return 'DeviceNotFoundException{ code: $code, message: $message }';
  }
}
