enum PermissionOutcomeType {
  success,
  failure,
  healthKitNotAvailable,
}

abstract class PermissionOutcome {
  final PermissionOutcomeType status;

  PermissionOutcome(this.status);

  factory PermissionOutcome.success() => PermissionResultSuccess();

  factory PermissionOutcome.failure(String message) =>
      PermissionResultFailure._init(PermissionOutcomeType.failure, message);

  factory PermissionOutcome.healthKitNotAvailable(String message) =>
      PermissionResultFailure._init(PermissionOutcomeType.healthKitNotAvailable, message);
}

class PermissionResultSuccess extends PermissionOutcome {
  PermissionResultSuccess() : super(PermissionOutcomeType.success);
}

class PermissionResultFailure extends PermissionOutcome {
  final String message;

  PermissionResultFailure._init(PermissionOutcomeType status, this.message) : super(status);
}
