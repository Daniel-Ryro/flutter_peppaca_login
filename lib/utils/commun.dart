// validation_util.dart
class ValidationUtil {
  static bool isValidEmail(String email) {
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool passwordMeetsRequirements(String password) {
    return password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\-]')) &&
        password.length >= 8;
  }
}
