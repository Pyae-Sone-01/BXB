String? nameValidator(value) =>
    value == null || value.isEmpty ? 'User Name is required' : null;
String? phoneValidator(value) =>
    value == null || value.isEmpty ? 'Phone is required' : null;

String? passwordValidator(value) =>
    value == null || value.isEmpty ? 'Password is required' : null;
String? emailValidator(value) {
  if (value == null || value.isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
  if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
  return null;
}

String? otpCodeValidator(value) {
  if (value == null || value.isEmpty) return 'Please enter OTP code';
  if (value.length != 4) return 'OTP must be 4 digits';
  return null;
}

String? pinValidator(value) {
  if (value == null || value.trim().isEmpty) {
    return 'PIN is required';
  }
  if (value.length != 6 || int.tryParse(value) == null) {
    return 'Enter a valid 6-digit PIN';
  }
  return null;
}
