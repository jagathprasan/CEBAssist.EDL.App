/// Form validation helpers used by authentication screens.
class Validators {
  Validators._();

  static final _usernamePattern = RegExp(r'^[\w.@+\-]{2,64}$');
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Please enter your username.';
    }
    if (!_usernamePattern.hasMatch(text)) {
      return 'Enter a valid CEBAssist username.';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Please enter your password.';
    }
    if (text.length < 5) {
      return 'Password must be at least 5 characters.';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    if (!_emailPattern.hasMatch(text)) {
      return "That email doesn't look quite right.";
    }
    return null;
  }

  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.length < 10) {
      return 'Password must be at least 10 characters.';
    }
    final hasUpper = text.contains(RegExp(r'[A-Z]'));
    final hasLower = text.contains(RegExp(r'[a-z]'));
    final hasDigit = text.contains(RegExp(r'[0-9]'));
    final hasSpecial = text.contains(RegExp(r'[^A-Za-z0-9]'));
    if (!hasUpper || !hasLower || !hasDigit || !hasSpecial) {
      return 'Include upper case, lower case, a number, and a symbol.';
    }
    return null;
  }

  static String? requiredField(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }
}
