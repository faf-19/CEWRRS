# CEWRRS API Documentation

## Overview
This document provides comprehensive API documentation for the CEWRRS (Community Emergency and Weather Reporting System) Flutter application.

## Security Utils

### OTP Generator (`core/utils/security/otp_generator.dart`)

#### OtpGenerator Class
- **Purpose**: Secure OTP code generation and validation
- **Security**: Uses cryptographically secure random generation
- **Expiry**: 5-minute expiry with attempt limiting

##### Methods
```dart
// Generate a secure OTP code
static String generateOtp({
  int length = 6,
  bool onlyNumbers = true,
})

// Generate OTP with expiry information
static OtpData generateOtpWithExpiry({
  int length = 6,
})

// Validate OTP code format
static bool isValidOtpFormat(String otp)
```

##### OtpData Class
```dart
// Check if OTP is expired
bool get isExpired

// Check if OTP can still be used
bool get canBeUsed

// Increment failed attempts
OtpData incrementAttempts()

// Mark OTP as used
OtpData markAsUsed()
```

### Password Utils (`core/utils/security/password_utils.dart`)

#### PasswordUtils Class
- **Purpose**: Secure password hashing and validation
- **Security**: Uses salt-based hashing for password security
- **Validation**: Comprehensive password strength validation

##### Methods
```dart
// Generate secure salt
static String generateSalt({int length = 32})

// Hash password with salt
static String hashPassword(String password, String salt)

// Hash password with auto-generated salt
static PasswordHashResult hashPasswordWithSalt(String password)

// Verify password against hash
static bool verifyPassword(String password, String hashedPassword, String salt)

// Validate password strength
static ValidationResult validatePassword(String password)

// Generate secure password
static String generateSecurePassword({
  int length = 12,
  bool includeUppercase = true,
  bool includeLowercase = true,
  bool includeNumbers = true,
  bool includeSpecialChars = true,
})
```

##### PasswordHashResult Class
```dart
// Convert to JSON for storage
Map<String, dynamic> toJson()

// Create from JSON
factory PasswordHashResult.fromJson(Map<String, dynamic> json)
```

##### PasswordValidationResult Class
```dart
// Get formatted error message
String get errorMessage

// Check if there are validation issues
bool get hasErrors
```

## Validation Utils

### Validators (`core/utils/validation/validators.dart`)

#### ValidationResult Class
```dart
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  // Get formatted error message
  String get errorMessage
  
  // Check if there are errors
  bool get hasErrors
  
  // Get first error message
  String get firstError
}
```

#### Validators Class
- **Purpose**: Centralized input validation for all forms
- **Coverage**: Phone numbers, emails, passwords, OTP, names, descriptions, severity levels

##### Methods
```dart
// Validate Ethiopian phone number
static ValidationResult validatePhoneNumber(String phone)

// Normalize Ethiopian phone number
static String? normalizePhoneNumber(String input)

// Validate email address
static ValidationResult validateEmail(String email)

// Validate password strength
static ValidationResult validatePassword(String password)

// Validate OTP code
static ValidationResult validateOtp(String otp)

// Validate user name
static ValidationResult validateName(String name)

// Validate description text
static ValidationResult validateDescription(String description)

// Validate severity selection
static ValidationResult validateSeverity(String severity)

// Validate location information
static ValidationResult validateLocation(String region, String woreda, String kebele)

// Validate multiple fields at once
static Map<String, ValidationResult> validateMultiple(Map<String, String> fields)

// Check if all validations pass
static bool areAllValid(Map<String, ValidationResult> validations)

// Get all error messages
static List<String> getAllErrors(Map<String, ValidationResult> validations)
```

## Local Storage Service

### LocalStorageService (`core/services/local_storage_service.dart`)

#### Features
- **Secure Storage**: Enhanced with OTP management
- **Data Management**: Generic data storage and retrieval
- **Report Management**: Emergency report storage and retrieval

##### Methods
```dart
// Report management
void saveReport(ReportModel report)
List<ReportModel> getAllReports()
void clearReports()

// OTP management
void saveOtp(OtpData otpData)
OtpData? getStoredOtp()
void removeOtp()

// Generic data management
void saveData(String key, dynamic data)
T? getData<T>(String key)
void removeData(String key)
void clearAll()
bool hasKey(String key)
```

## Controllers

### AuthController (`presentation/controllers/auth_controller.dart`)

#### Features
- **Secure OTP**: Integration with OtpGenerator
- **Validation**: Uses centralized Validators
- **Storage**: Secure OTP storage via LocalStorageService

##### Methods
```dart
// OTP management
void sendOtp()
void verifyOtp()
void resendOtp()
bool get isOtpVerified

// Reset functionality
void _resetOtp()
```

### LoginController (`presentation/controllers/login_controller.dart`)

#### Features
- **Secure Authentication**: Password hashing via PasswordUtils
- **Validation**: Comprehensive input validation
- **User Management**: Support for public and staff users

##### Methods
```dart
// User management
void addUser(String phone, String password, {bool isStaff = false})
bool userExists(String phone, {bool isStaff = false})

// Authentication
void login()
bool isLoggedIn()
String? getCurrentUser()
UserType? getCurrentUserType()
void logout()

// UI state
void setUserType(UserType userType)
```

## Data Models

### UserModel (`data/models/user_model.dart`)

#### Properties
```dart
final String phone
final String name
final UserType userType
final DateTime createdAt
```

#### Methods
```dart
// JSON serialization
Map<String, dynamic> toJson()
factory UserModel.fromJson(Map<String, dynamic> json)
```

### ReportModel (`data/models/report_model.dart`)

#### Properties
```dart
final String region
final String woreda
final String kebele
final String date
final String time
final String description
final String severity
final String imagePath
```

#### Methods
```dart
// JSON serialization
Map<String, dynamic> toJson()
factory ReportModel.fromJson(Map<String, dynamic> json)
```

## Usage Examples

### Basic OTP Flow
```dart
final authController = Get.find<AuthController>();

// Send OTP
authController.phone.text = "+251911234567";
authController.sendOtp();

// Verify OTP
authController.otp.text = "123456";
authController.verifyOtp();

// Check verification status
if (authController.isOtpVerified) {
  // Proceed with next step
}
```

### Secure Login
```dart
final loginController = Get.find<LoginController>();

// Set user type
loginController.setUserType(UserType.public);

// Validate and login
final phoneValidation = Validators.validatePhoneNumber(phoneController.text);
final passwordValidation = Validators.validatePassword(passwordController.text);

if (phoneValidation.isValid && passwordValidation.isValid) {
  loginController.login();
}
```

### Secure Password Registration
```dart
// Generate secure password
final securePassword = PasswordUtils.generateSecurePassword();

// Validate password
final validation = PasswordUtils.validatePassword(password);
if (validation.isValid) {
  // Hash and store password
  final hashedPassword = PasswordUtils.hashPasswordWithSalt(password);
  loginController.addUser(phone, password);
}
```

## Error Handling

### Validation Errors
```dart
final validation = Validators.validatePhoneNumber("invalid");
if (!validation.isValid) {
  // Handle validation errors
  List<String> errors = validation.errors;
  String errorMessage = validation.errorMessage;
}
```

### Security Exceptions
```dart
// OTP expired
if (otpData.isExpired) {
  // Request new OTP
  authController.resendOtp();
}

// Password too weak
final passwordValidation = Validators.validatePassword("123");
if (!passwordValidation.isValid) {
  // Show password requirements
  String errorMsg = passwordValidation.errorMessage;
}
```

## Security Best Practices

1. **Never store plain text passwords**
2. **Always validate user input**
3. **Use secure OTP generation**
4. **Implement proper expiry handling**
5. **Clean up sensitive data**
6. **Use proper error handling**

## Migration Guide

### From Hardcoded OTP
```dart
// OLD (insecure)
if (otp.text == "1234") {
  // Grant access
}

// NEW (secure)
void verifyOtp() {
  final otpValidation = Validators.validateOtp(otp.text);
  if (!otpValidation.isValid) return;
  
  if (_currentOtp?.code != otp.text) {
    // Handle invalid OTP
    return;
  }
  // Grant access
}
```

### From Plain Text Passwords
```dart
// OLD (insecure)
users[phone] = password;

// NEW (secure)
final passwordHash = PasswordUtils.hashPasswordWithSalt(password);
users[phone] = {
  'hashedPassword': passwordHash.hashedPassword,
  'salt': passwordHash.salt,
};
```

## Testing

### Unit Tests
- OTP generation and validation
- Password hashing and verification
- Input validation
- Local storage operations

### Integration Tests
- Auth flow with secure OTP
- Login with hashed passwords
- Data persistence

---

**Last Updated**: 2025-11-16  
**Version**: 1.0.0  
**Status**: Production Ready