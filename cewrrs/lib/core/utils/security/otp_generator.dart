import 'dart:math';

/// Utility class for generating and validating secure OTP codes
/// This replaces hardcoded OTP values with cryptographically secure random codes
class OtpGenerator {
  static const int _defaultLength = 6;
  static const String _digits = '0123456789';
  static const int _maxAttempts = 3;
  static const Duration _expiryDuration = Duration(minutes: 5);

  /// Generate a secure OTP code
  static String generateOtp({
    int length = _defaultLength,
    bool onlyNumbers = true,
  }) {
    final random = Random.secure();
    final code = StringBuffer();
    
    for (int i = 0; i < length; i++) {
      final index = random.nextInt(onlyNumbers ? _digits.length : 36);
      code.write(onlyNumbers ? _digits[index] : _digits[index]);
    }
    
    return code.toString();
  }

  /// Validate OTP code format
  static bool isValidOtpFormat(String otp) {
    if (otp.isEmpty) return false;
    if (otp.length < _defaultLength) return false;
    return RegExp(r'^\d{$_defaultLength}$').hasMatch(otp);
  }

  /// Generate OTP with expiry information
  static OtpData generateOtpWithExpiry({
    int length = _defaultLength,
  }) {
    final code = generateOtp(length: length);
    final expiryTime = DateTime.now().add(_expiryDuration);
    
    return OtpData(
      code: code,
      expiryTime: expiryTime,
    );
  }
}

/// Data class to hold OTP code with expiry information
class OtpData {
  final String code;
  final DateTime expiryTime;
  final int attempts;
  final bool isUsed;

  OtpData({
    required this.code,
    required this.expiryTime,
    this.attempts = 0,
    this.isUsed = false,
  });

  /// Check if OTP is expired
  bool get isExpired => DateTime.now().isAfter(expiryTime);

  /// Check if OTP can still be used (not expired, not used, attempts < max)
  bool get canBeUsed => !isExpired && !isUsed && attempts < 3;

  /// Create a new OtpData with incremented attempts
  OtpData incrementAttempts() {
    return OtpData(
      code: code,
      expiryTime: expiryTime,
      attempts: attempts + 1,
      isUsed: isUsed,
    );
  }

  /// Create a new OtpData marked as used
  OtpData markAsUsed() {
    return OtpData(
      code: code,
      expiryTime: expiryTime,
      attempts: attempts,
      isUsed: true,
    );
  }

  @override
  String toString() {
    return 'OtpData(code: $code, expiryTime: $expiryTime, attempts: $attempts, isUsed: $isUsed)';
  }
}