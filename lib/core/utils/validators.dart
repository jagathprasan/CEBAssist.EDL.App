/// Form validation helpers used by authentication screens.
class Validators {
  Validators._();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _employeeIdPattern = RegExp(r'^\d{4,8}$');

  static String? identifier(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Please enter your employee ID or email.';
    }
    if (text.contains('@')) {
      if (!_emailPattern.hasMatch(text)) {
        return "That email doesn't look quite right.";
      }
      return null;
    }
    if (!_employeeIdPattern.hasMatch(text)) {
      return 'Enter a valid employee ID or a work email address.';
    }
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Please enter your password.';
    }
    if (text.length < 6) {
      return 'Password must be at least 6 characters.';
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
