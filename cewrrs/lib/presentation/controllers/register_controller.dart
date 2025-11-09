import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  final storage = GetStorage();
  
  // Key for storing users in GetStorage (should match LoginController)
  final String _usersKey = 'stored_users';
  final String _usernamesKey = 'user_usernames'; // To store phone -> username mapping

  void register() {
    final rawPhone = phoneController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    // Validate phone number
    final phone = _normalizePhone(rawPhone);
    if (phone == null) {
      Get.snackbar("Invalid Phone", "Please enter a valid Ethiopian phone number.");
      return;
    }

    if (username.isEmpty) {
      Get.snackbar("Invalid Username", "Please enter a username.");
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Weak Password", "Password must be at least 6 characters long.");
      return;
    }

    if (password != confirm) {
      Get.snackbar("Password Mismatch", "Passwords do not match.");
      return;
    }

    // Check if user already exists
    if (_userExists(phone)) {
      Get.snackbar("User Exists", "An account with this phone number already exists.");
      return;
    }

    isLoading.value = true;

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      // Save user to storage
      _saveUser(phone, password, username);
      
      isLoading.value = false;
      Get.snackbar("Success", "Account created for $username");
      Get.toNamed('/login');
    });
  }

  // Get all stored users from GetStorage
  Map<String, String> _getStoredUsers() {
    final storedUsers = storage.read(_usersKey);
    if (storedUsers is Map) {
      return Map<String, String>.from(storedUsers);
    }
    return {};
  }

  // Get username mapping from GetStorage
  Map<String, String> _getUsernameMapping() {
    final storedUsernames = storage.read(_usernamesKey);
    if (storedUsernames is Map) {
      return Map<String, String>.from(storedUsernames);
    }
    return {};
  }

  // Save user to GetStorage
  void _saveUser(String phone, String password, String username) {
    // Save phone -> password mapping
    final users = _getStoredUsers();
    users[phone] = password;
    storage.write(_usersKey, users);

    // Save phone -> username mapping
    final usernames = _getUsernameMapping();
    usernames[phone] = username;
    storage.write(_usernamesKey, usernames);

    // Also store user details for profile access
    storage.write('user_$phone', {
      'username': username,
      'phone': phone,
      'registeredAt': DateTime.now().toIso8601String(),
    });
  }

  // Check if user already exists
  bool _userExists(String phone) {
    final users = _getStoredUsers();
    return users.containsKey(phone);
  }

  // Get username by phone number
  String? getUsernameByPhone(String phone) {
    final usernames = _getUsernameMapping();
    return usernames[phone];
  }

  // Normalize phone number (same as LoginController)
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

  @override
  void onClose() {
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
