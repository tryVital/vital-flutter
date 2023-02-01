import 'package:vital_core/exceptions.dart';

class UnsupportedDataPushModeException extends VitalException {
  UnsupportedDataPushModeException(String message)
      : super("UnsupportedDataPushMode", message);

  @override
  String toString() {
    return 'UnsupportedDataPushModeException{ code: $code, message: $message }';
  }
}
