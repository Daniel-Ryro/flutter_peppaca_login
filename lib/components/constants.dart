class Constants {
  static const int primaryCOLOR = 0xFFC2612C;
  static const int hintCOLOR = 0xFF6E6E6E;
  static const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');
  static const bool kProfileMode = bool.fromEnvironment('dart.vm.profile');
  static const bool kDebugMode = !kReleaseMode && !kProfileMode;
  static const int maxFailedAttempts = 5;
  static const int maxLockedMinutes = 60;
  static const double screenWidth = 375;
  static const int screentHeight = 812;
}

enum FormzSubmissionStatus {
  /// The form has not yet been submitted.
  initial,

  /// The form is in the process of being submitted.
  inProgress,

  /// The form has been submitted successfully.
  success,

  /// The form submission failed.
  failure,

  /// The form submission has been canceled.
  canceled
}
