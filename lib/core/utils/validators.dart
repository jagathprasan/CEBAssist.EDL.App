/// Form validation helpers used by authentication screens.
class Validators {
  Validators._();

  static final _usernamePattern = RegExp(r'^[\w.@+\-]{2,64}$');

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

  static String? requiredField(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }
}
