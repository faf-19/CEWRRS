/// Comprehensive input validation utilities for CEWRRS application
/// This replaces scattered validation logic across controllers with centralized validation

/// Validation result class to encapsulate validation outcome
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult(this.isValid, this.errors);

  /// Get formatted error message
  String get errorMessage {
    if (isValid) return '';
    return errors.join('. ');
  }

  /// Check if there are no errors
  bool get hasErrors => errors.isNotEmpty;

  /// Get first error message or empty string
  String get firstError => errors.isNotEmpty ? errors.first : '';

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, errors: $errors)';
  }
}

/// Comprehensive input validation utilities for CEWRRS application
class Validators {
  // Phone number validation patterns
  static const String _ethiopianPhonePattern = r'^\+2519\d{8}$';  // +2519XXXXXXXX (12 digits)
  static const String _primaryEthiopianPattern = r'^09\d{8}$';    // 09XXXXXXXX (10 digits including 0)
  static const String _alternativeEthiopianPattern = r'^9\d{8}$'; // 9XXXXXXXX (9 digits)

  // Email validation pattern
  static const String _emailPattern = 
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Password patterns
  static const int _minPasswordLength = 8;
  
  // Validation results
  static const Map<String, String> _errorMessages = {
    'empty_field': 'This field cannot be empty',
    'invalid_phone': 'Please enter a valid 10-digit phone number starting with 0 (e.g., 0911123456)',
    'invalid_email': 'Please enter a valid email address',
    'password_too_short': 'Password must be at least $_minPasswordLength characters long',
    'password_no_uppercase': 'Password must contain at least one uppercase letter',
    'password_no_lowercase': 'Password must contain at least one lowercase letter',
    'password_no_number': 'Password must contain at least one number',
    'password_no_special': 'Password must contain at least one special character',
    'invalid_otp': 'Please enter a valid 6-digit OTP code',
    'name_too_short': 'Name must be at least 2 characters long',
    'invalid_description': 'Description must be between 10 and 500 characters',
    'invalid_severity': 'Please select a valid severity level',
    'invalid_location': 'Please provide a valid location',
  };

  /// Validate Ethiopian phone number
  static ValidationResult validatePhoneNumber(String phone) {
    if (phone.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    // Simplified validation: just check for exactly 10 digits starting with 0
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.length == 10 && cleanPhone.startsWith('0')) {
      return ValidationResult(true, []);
    }

    return ValidationResult(false, [_errorMessages['invalid_phone']!]);
  }

  /// Normalize Ethiopian phone number to standard format
  static String? normalizePhoneNumber(String input) {
    final cleanInput = input.replaceAll(RegExp(r'[^+\d]'), '');
    
    // +2519XXXXXXXX format (already normalized)
    if (RegExp(_ethiopianPhonePattern).hasMatch(cleanInput)) {
      return cleanInput;
    }
    
    // 09XXXXXXXX format (10 digits starting with 0)
    if (RegExp(_primaryEthiopianPattern).hasMatch(cleanInput)) {
      return '+251' + cleanInput.substring(1);
    }

    // 9XXXXXXXX format (9 digits starting with 9)
    if (RegExp(_alternativeEthiopianPattern).hasMatch(cleanInput)) {
      return '+251' + cleanInput;
    }
    
    return null; // Invalid phone number
  }

  /// Validate email address
  static ValidationResult validateEmail(String email) {
    if (email.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    if (RegExp(_emailPattern).hasMatch(email.trim())) {
      return ValidationResult(true, []);
    }

    return ValidationResult(false, [_errorMessages['invalid_email']!]);
  }

  /// Validate password strength
  static ValidationResult validatePassword(String password) {
    if (password.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    // Temporarily relaxed validation for testing
    if (password.length < 6) {
      return ValidationResult(false, ['Password must be at least 6 characters long']);
    }

    return ValidationResult(true, []);

    // Original strict validation (commented out for testing)
    /*
    final issues = <String>[];

    if (password.length < _minPasswordLength) {
      issues.add(_errorMessages['password_too_short']!);
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      issues.add(_errorMessages['password_no_uppercase']!);
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      issues.add(_errorMessages['password_no_lowercase']!);
    }
    if (!password.contains(RegExp(r'\d'))) {
      issues.add(_errorMessages['password_no_number']!);
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add(_errorMessages['password_no_special']!);
    }

    return ValidationResult(issues.isEmpty, issues);
    */
  }

  /// Validate OTP code
  static ValidationResult validateOtp(String otp) {
    if (otp.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    if (otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp)) {
      return ValidationResult(true, []);
    }

    return ValidationResult(false, [_errorMessages['invalid_otp']!]);
  }

  /// Validate user name
  static ValidationResult validateName(String name) {
    if (name.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    if (name.trim().length < 2) {
      return ValidationResult(false, [_errorMessages['name_too_short']!]);
    }

    // Check for valid characters (letters, numbers, spaces, basic punctuation)
    if (!RegExp(r"^[a-zA-Z0-9\s\-.\']+\$").hasMatch(name)) {
      return ValidationResult(false, ['Name contains invalid characters']);
    }

    return ValidationResult(true, []);
  }

  /// Validate description text
  static ValidationResult validateDescription(String description) {
    if (description.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    if (description.length < 10) {
      return ValidationResult(false, ['Description must be at least 10 characters long']);
    }

    if (description.length > 500) {
      return ValidationResult(false, ['Description cannot exceed 500 characters']);
    }

    return ValidationResult(true, []);
  }

  /// Validate severity selection
  static ValidationResult validateSeverity(String severity) {
    final validSeverities = ['Low', 'Medium', 'High', 'Critical'];
    
    if (severity.trim().isEmpty) {
      return ValidationResult(false, [_errorMessages['empty_field']!]);
    }

    if (validSeverities.contains(severity.trim())) {
      return ValidationResult(true, []);
    }

    return ValidationResult(false, [_errorMessages['invalid_severity']!]);
  }

  /// Validate location information
  static ValidationResult validateLocation(String region, String woreda, String kebele) {
    final issues = <String>[];

    if (region.trim().isEmpty) {
      issues.add('Region is required');
    }

    if (woreda.trim().isEmpty) {
      issues.add('Woreda is required');
    }

    if (kebele.trim().isEmpty) {
      issues.add('Kebele is required');
    }

    return ValidationResult(issues.isEmpty, issues);
  }

  /// Validate multiple fields at once
  static Map<String, ValidationResult> validateMultiple(Map<String, String> fields) {
    final results = <String, ValidationResult>{};

    fields.forEach((fieldName, value) {
      switch (fieldName.toLowerCase()) {
        case 'phone':
          results[fieldName] = validatePhoneNumber(value);
          break;
        case 'email':
          results[fieldName] = validateEmail(value);
          break;
        case 'password':
          results[fieldName] = validatePassword(value);
          break;
        case 'otp':
          results[fieldName] = validateOtp(value);
          break;
        case 'name':
          results[fieldName] = validateName(value);
          break;
        case 'description':
          results[fieldName] = validateDescription(value);
          break;
        case 'severity':
          results[fieldName] = validateSeverity(value);
          break;
        default:
          // Generic validation for unknown fields
          results[fieldName] = value.trim().isNotEmpty 
              ? ValidationResult(true, []) 
              : ValidationResult(false, [_errorMessages['empty_field']!]);
      }
    });

    return results;
  }

  /// Check if all validations pass
  static bool areAllValid(Map<String, ValidationResult> validations) {
    return validations.values.every((result) => result.isValid);
  }

  /// Get all error messages from validations
  static List<String> getAllErrors(Map<String, ValidationResult> validations) {
    return validations.values
        .where((result) => !result.isValid)
        .expand((result) => result.errors)
        .toList();
  }
}