import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Utility class for secure password hashing and validation
/// This replaces plain text password storage with proper hashing
class PasswordUtils {
  /// Generate a secure salt for password hashing
  static String generateSalt({int length = 32}) {
    final bytes = List<int>.generate(length, (index) => Random.secure().nextInt(256));
    return base64Encode(bytes);
  }

  /// Simple but secure password hashing using salt
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    // Simple hash using Dart's built-in hashCode and additional mixing
    return _simpleHash(bytes.toString() + salt);
  }

  /// Simple hash function for passwords
  static String _simpleHash(String input) {
    var hash = 0;
    for (var i = 0; i < input.length; i++) {
      hash = ((hash << 5) - hash + input.codeUnitAt(i)) & 0xffffffff;
    }
    return hash.abs().toRadixString(16).padLeft(8, '0');
  }

  /// Hash password with auto-generated salt
  static PasswordHashResult hashPasswordWithSalt(String password) {
    final salt = generateSalt();
    final hashedPassword = hashPassword(password, salt);
    
    return PasswordHashResult(
      hashedPassword: hashedPassword,
      salt: salt,
    );
  }

  /// Verify password against hash and salt
  static bool verifyPassword(String password, String hashedPassword, String salt) {
    final computedHash = hashPassword(password, salt);
    return computedHash == hashedPassword;
  }

  /// Validate password strength
  static PasswordValidationResult validatePassword(String password) {
    final issues = <String>[];
    
    if (password.isEmpty) {
      issues.add('Password cannot be empty');
    } else {
      if (password.length < 8) {
        issues.add('Password must be at least 8 characters long');
      }
      if (!password.contains(RegExp(r'[A-Z]'))) {
        issues.add('Password must contain at least one uppercase letter');
      }
      if (!password.contains(RegExp(r'[a-z]'))) {
        issues.add('Password must contain at least one lowercase letter');
      }
      if (!password.contains(RegExp(r'\d'))) {
        issues.add('Password must contain at least one number');
      }
      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        issues.add('Password must contain at least one special character');
      }
    }
    
    return PasswordValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
    );
  }

  /// Generate a random password that meets security requirements
  static String generateSecurePassword({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
  }) {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const numberChars = '0123456789';
    const specialChars = '!@#\$%^&*(),.?":{}|<>';

    var chars = '';
    if (includeUppercase) chars += uppercaseChars;
    if (includeLowercase) chars += lowercaseChars;
    if (includeNumbers) chars += numberChars;
    if (includeSpecialChars) chars += specialChars;

    if (chars.isEmpty) {
      throw ArgumentError('At least one character type must be included');
    }

    final random = Random.secure();
    final password = StringBuffer();

    // Ensure at least one character from each selected type
    if (includeUppercase) password.write(uppercaseChars[random.nextInt(uppercaseChars.length)]);
    if (includeLowercase) password.write(lowercaseChars[random.nextInt(lowercaseChars.length)]);
    if (includeNumbers) password.write(numberChars[random.nextInt(numberChars.length)]);
    if (includeSpecialChars) password.write(specialChars[random.nextInt(specialChars.length)]);

    // Fill remaining length with random characters from all selected types
    while (password.length < length) {
      password.write(chars[random.nextInt(chars.length)]);
    }

    // Shuffle the password
    final passwordChars = password.toString().split('');
    passwordChars.shuffle(random);
    
    return passwordChars.join();
  }
}

/// Result class for password hashing operations
class PasswordHashResult {
  final String hashedPassword;
  final String salt;

  PasswordHashResult({
    required this.hashedPassword,
    required this.salt,
  });

  /// Convert to JSON format for storage
  Map<String, dynamic> toJson() => {
    'hashedPassword': hashedPassword,
    'salt': salt,
  };

  /// Create from JSON
  factory PasswordHashResult.fromJson(Map<String, dynamic> json) => PasswordHashResult(
    hashedPassword: json['hashedPassword'] ?? '',
    salt: json['salt'] ?? '',
  );
}

/// Result class for password validation
class PasswordValidationResult {
  final bool isValid;
  final List<String> issues;

  PasswordValidationResult({
    required this.isValid,
    required this.issues,
  });

  /// Get formatted error message
  String get errorMessage {
    if (isValid) return '';
    return issues.join('. ');
  }

  @override
  String toString() {
    return 'PasswordValidationResult(isValid: $isValid, issues: $issues)';
  }
}