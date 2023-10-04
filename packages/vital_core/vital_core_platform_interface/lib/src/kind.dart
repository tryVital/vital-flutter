enum DeviceKind { bloodPressure, glucoseMeter }

DeviceKind kindFromString(String kind) {
  switch (kind) {
    case "bloodPressure":
      return DeviceKind.bloodPressure;
    case "glucoseMeter":
      return DeviceKind.glucoseMeter;
    default:
      throw Exception("Unknown kind: $kind");
  }
}
