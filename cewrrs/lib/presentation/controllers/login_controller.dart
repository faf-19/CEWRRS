import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Observable to track if form is valid
  final RxBool isFormValid = false.obs;

  final storage = GetStorage();
  
  // Key for storing users in GetStorage
  final String _usersKey = 'stored_users';

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

  void _checkFormValidity() {
    final phoneValid = phoneController.text.trim().isNotEmpty;
    final passwordValid = passwordController.text.isNotEmpty;
    isFormValid.value = phoneValid && passwordValid;
  }

  // Get all stored users from GetStorage
  Map<String, String> getStoredUsers() {
    final storedUsers = storage.read(_usersKey);
    if (storedUsers is Map) {
      return Map<String, String>.from(storedUsers);
    }
    return {};
  }

  // Save users to GetStorage
  void _saveUsers(Map<String, String> users) {
    storage.write(_usersKey, users);
  }

  // Initialize with sample users if no users exist
  void _initializeSampleUsers() {
    final existingUsers = getStoredUsers();
    if (existingUsers.isEmpty) {
      final sampleUsers = {
        // Canonical international format: +2519XXXXXXXX
        '+251911111111': 'password123',
        '+251922334455': 'secret456',
        '+251912121212': 'password1212',
      };
      _saveUsers(sampleUsers);
    }
  }

  // Add a new user (useful for registration)
  void addUser(String phone, String password) {
    final normalizedPhone = _normalizePhone(phone);
    if (normalizedPhone == null) return;

    final users = getStoredUsers();
    users[normalizedPhone] = password;
    _saveUsers(users);
  }

  // Check if user exists
  bool userExists(String phone) {
    final normalizedPhone = _normalizePhone(phone);
    if (normalizedPhone == null) return false;

    final users = getStoredUsers();
    return users.containsKey(normalizedPhone);
  }

  void login() async {
    final rawInput = phoneController.text.trim();
    final password = passwordController.text;

    final phone = _normalizePhone(rawInput);
    if (phone == null) {
      Get.snackbar(
        "Invalid Phone",
        "Please enter a valid Ethiopian phone number.",
      );
      return;
    }

    // Get users from storage instead of mock data
    final storedUsers = getStoredUsers();

    if (!storedUsers.containsKey(phone)) {
      Get.snackbar("User Not Found", "No account found for this phone number.");
      return;
    }

    if (storedUsers[phone] != password) {
      Get.snackbar(
        "Incorrect Password",
        "Please check your password and try again.",
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Store login session
    storage.write('current_user', phone);
    storage.write('is_logged_in', true);

    Get.snackbar("Login Successful", "Welcome back!");
    Get.toNamed('/home');
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return storage.read('is_logged_in') == true;
  }

  // Get current user
  String? getCurrentUser() {
    return storage.read('current_user');
  }

  // Logout
  void logout() {
    storage.remove('current_user');
    storage.write('is_logged_in', false);
  }


  String? _normalizePhone(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^+\d]'), '');
    // +2519XXXXXXXX
    if (RegExp(r'^\+2519\d{8}$').hasMatch(cleaned)) return cleaned;
    // 09XXXXXXXX
    if (RegExp(r'^09\d{8}$').hasMatch(cleaned)) {
      return '+251' + cleaned.substring(1);
    }
    // 9XXXXXXXX
    if (RegExp(r'^9\d{8}$').hasMatch(cleaned)) {
      return '+251' + cleaned;
    }
    return null;
  }
}
