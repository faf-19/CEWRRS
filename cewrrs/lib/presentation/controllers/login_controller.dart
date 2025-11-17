import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/validation/validators.dart';
import '../../core/utils/security/password_utils.dart';
import '../../core/services/local_storage_service.dart';

/// LoginController with improved security and validation
/// This addresses the critical security issue of plain text password storage
class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Observable to track if form is valid
  final RxBool isFormValid = false.obs;

  final storage = GetStorage();
  final LocalStorageService _localStorage = LocalStorageService();
  
  // Key for storing users in GetStorage
  final String _usersKey = 'stored_users';
  final String _staffUsersKey = 'stored_staff_users';

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to update form validity
    phoneController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
    
    // Initialize with some sample users if none exist (for testing)
    _initializeSampleUsers();
  }

  @override
  void onClose() {
    phoneController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Check form validity using centralized validation
  void _checkFormValidity() {
    final phoneValidation = Validators.validatePhoneNumber(phoneController.text);
    final passwordValidation = Validators.validatePassword(passwordController.text);
    isFormValid.value = phoneValidation.isValid && passwordValidation.isValid;
  }

  /// Get all stored users from GetStorage with hashed passwords
  Map<String, Map<String, String>> getStoredUsers() {
    final storedUsers = storage.read(_usersKey);
    if (storedUsers is Map) {
      return Map<String, Map<String, String>>.from(storedUsers.map((key, value) => MapEntry(key, Map<String, String>.from(value))));
    }
    return {};
  }

  /// Get all stored staff users from GetStorage with hashed passwords
  Map<String, Map<String, String>> getStoredStaffUsers() {
    final storedStaffUsers = storage.read(_staffUsersKey);
    if (storedStaffUsers is Map) {
      return Map<String, Map<String, String>>.from(storedStaffUsers.map((key, value) => MapEntry(key, Map<String, String>.from(value))));
    }
    return {};
  }

  /// Save users to GetStorage with hashed passwords
  void _saveUsers(Map<String, Map<String, String>> users, {bool isStaff = false}) {
    if (isStaff) {
      storage.write(_staffUsersKey, users);
    } else {
      storage.write(_usersKey, users);
    }
  }

  /// Initialize with sample users using secure password hashing
  void _initializeSampleUsers() {
    final existingUsers = getStoredUsers();
    final existingStaffUsers = getStoredStaffUsers();
    
    if (existingUsers.isEmpty) {
      final sampleUsers = <String, Map<String, String>>{};
      
      // Create hashed passwords for sample users
      final passwordHashes = [
        'password123',
        'secret456',
        'password1212',
      ];
      
      final phones = [
        '+251911111111',
        '+251922334455',
        '+251912121212',
      ];
      
      for (int i = 0; i < phones.length; i++) {
        final passwordHash = PasswordUtils.hashPasswordWithSalt(passwordHashes[i]);
        sampleUsers[phones[i]] = {
          'hashedPassword': passwordHash.hashedPassword,
          'salt': passwordHash.salt,
        };
      }
      
      _saveUsers(sampleUsers);
    }
    
    if (existingStaffUsers.isEmpty) {
      final sampleStaffUsers = <String, Map<String, String>>{};
      
      final staffPasswords = [
        'staff123',
        'admin456',
      ];
      
      final staffPhones = [
        '+251988888888',
        '+251977777777',
      ];
      
      for (int i = 0; i < staffPhones.length; i++) {
        final passwordHash = PasswordUtils.hashPasswordWithSalt(staffPasswords[i]);
        sampleStaffUsers[staffPhones[i]] = {
          'hashedPassword': passwordHash.hashedPassword,
          'salt': passwordHash.salt,
        };
      }
      
      _saveUsers(sampleStaffUsers, isStaff: true);
    }
  }

  /// Add a new user with secure password hashing
  void addUser(String phone, String password, {bool isStaff = false}) {
    // Validate inputs first
    final phoneValidation = Validators.validatePhoneNumber(phone);
    if (!phoneValidation.isValid) {
      Get.snackbar("Invalid Phone", phoneValidation.errorMessage);
      return;
    }
    
    final passwordValidation = Validators.validatePassword(password);
    if (!passwordValidation.isValid) {
      Get.snackbar("Invalid Password", passwordValidation.errorMessage);
      return;
    }

    final normalizedPhone = Validators.normalizePhoneNumber(phone);
    if (normalizedPhone == null) return;

    // Hash the password securely
    final passwordHash = PasswordUtils.hashPasswordWithSalt(password);
    final userData = {
      'hashedPassword': passwordHash.hashedPassword,
      'salt': passwordHash.salt,
    };

    if (isStaff) {
      final users = getStoredStaffUsers();
      users[normalizedPhone] = userData;
      _saveUsers(users, isStaff: true);
    } else {
      final users = getStoredUsers();
      users[normalizedPhone] = userData;
      _saveUsers(users);
    }
    
    Get.snackbar("Success", "User registered successfully");
  }

  /// Check if user exists
  bool userExists(String phone, {bool isStaff = false}) {
    final normalizedPhone = Validators.normalizePhoneNumber(phone);
    if (normalizedPhone == null) return false;

    if (isStaff) {
      final users = getStoredStaffUsers();
      return users.containsKey(normalizedPhone);
    } else {
      final users = getStoredUsers();
      return users.containsKey(normalizedPhone);
    }
  }

  /// Login with secure password verification
  void login() async {
    // Validate inputs using centralized validation
    final phoneValidation = Validators.validatePhoneNumber(phoneController.text);
    if (!phoneValidation.isValid) {
      Get.snackbar("Invalid Phone", phoneValidation.errorMessage);
      return;
    }

    final passwordValidation = Validators.validatePassword(passwordController.text);
    if (!passwordValidation.isValid) {
      Get.snackbar("Invalid Password", passwordValidation.errorMessage);
      return;
    }

    final phone = Validators.normalizePhoneNumber(phoneController.text.trim());
    if (phone == null) {
      Get.snackbar("Error", "Unable to process phone number");
      return;
    }

    final password = passwordController.text;

    // Determine user type by checking which storage contains the phone number
    UserType userType;
    Map<String, Map<String, String>> storedUsers;

    if (getStoredStaffUsers().containsKey(phone)) {
      userType = UserType.staff;
      storedUsers = getStoredStaffUsers();
    } else if (getStoredUsers().containsKey(phone)) {
      userType = UserType.public;
      storedUsers = getStoredUsers();
    } else {
      Get.snackbar("User Not Found", "No account found for this phone number.");
      return;
    }

    String userTypeName = userType == UserType.staff ? 'Staff' : 'Public';

    if (!storedUsers.containsKey(phone)) {
      Get.snackbar("User Not Found", "No $userTypeName account found for this phone number.");
      return;
    }

    // Verify password using secure hashing
    final userData = storedUsers[phone]!;
    final hashedPassword = userData['hashedPassword']!;
    final salt = userData['salt']!;
    
    final isPasswordValid = PasswordUtils.verifyPassword(password, hashedPassword, salt);
    if (!isPasswordValid) {
      Get.snackbar(
        "Incorrect Password",
        "Please check your password and try again.",
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Store login session with user type
    storage.write('current_user', phone);
    storage.write('is_logged_in', true);
    storage.write('user_type', userType.toString().split('.').last);

    Get.snackbar("Login Successful", "Welcome back $userTypeName user!");

    // Navigate based on user type
    if (userType == UserType.staff) {
      Get.toNamed('/home'); // Staff go to home with staff features
    } else {
      Get.toNamed('/home'); // Public users also go to home, but with different navigation
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return storage.read('is_logged_in') == true;
  }

  /// Get current user
  String? getCurrentUser() {
    return storage.read('current_user');
  }

  /// Get current user type
  UserType? getCurrentUserType() {
    final userTypeString = storage.read('user_type');
    if (userTypeString != null) {
      return UserType.values.firstWhere(
        (e) => e.toString().split('.').last == userTypeString,
        orElse: () => UserType.public,
      );
    }
    return null;
  }

  /// Logout
  void logout() {
    storage.remove('current_user');
    storage.write('is_logged_in', false);
    storage.remove('user_type');
  }

}
