enum ClientStatus {
  /// The SDK has been configured, either through `VitalClient.Type.configure` for the first time,
  /// or through `VitalClient.Type.automaticConfiguration()` where the last auto-saved
  /// configuration has been restored.
  configured,

  /// The SDK has an active sign-in.
  signedIn,

  /// The active sign-in was done through an explicitly set target User ID, paired with a Vital API Key.
  /// (through `VitalClient.Type.setUserId(_:)`)
  ///
  /// Not recommended for production apps.
  useApiKey,

  /// The active sign-in is done through a Vital Sign-In Token via `VitalClient.Type.signIn`.
  useSignInToken,

  /// A Vital Sign-In Token sign-in session that is currently on hold, requiring re-authentication using
  /// a new Vital Sign-In Token issued for the same user.
  ///
  /// This generally should not happen, as Vital's identity broker guarantees only to revoke auth
  /// refresh tokens when a user is explicitly deleted, disabled or have their tokens explicitly
  /// revoked.
  pendingReauthentication;

  static ClientStatus? fromString(String rawValue) {
    try {
      return ClientStatus.values
          .firstWhere((element) => element.name == rawValue);
    } catch (err) {
      assert(err is StateError);
      return null;
    }
  }
}
