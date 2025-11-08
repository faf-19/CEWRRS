import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  // Observable to track if form is valid
  final RxBool isFormValid = false.obs;

  final mockUsers = {
    // Canonical international format: +2519XXXXXXXX
    '+251911111111': 'password123',
    '+251922334455': 'secret456',
    '+251912121212': 'password1212',
  };

  final storage = GetStorage();
  final Map<String, String> _normalizedMockUsers = {};

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to update form validity
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
    // Build normalized mock user map
    _normalizedMockUsers.clear();
    mockUsers.forEach((raw, pwd) {
      final norm = _normalizePhone(raw);
      if (norm != null) {
        _normalizedMockUsers[norm] = pwd;
      }
    });
  }

  @override
  void onClose() {
    emailController.removeListener(_checkFormValidity);
    passwordController.removeListener(_checkFormValidity);
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _checkFormValidity() {
    final phoneValid = emailController.text.trim().isNotEmpty;
    final passwordValid = passwordController.text.isNotEmpty;
    isFormValid.value = phoneValid && passwordValid;
  }

  void login() async {
    final rawInput = emailController.text.trim();
    final password = passwordController.text;

    final phone = _normalizePhone(rawInput);
    if (phone == null) {
      Get.snackbar(
        "Invalid Phone",
        "Please enter a valid Ethiopian phone number.",
      );
      return;
    }

    if (!_normalizedMockUsers.containsKey(phone)) {
      Get.snackbar("User Not Found", "No account found for this phone number.");
      return;
    }

    if (_normalizedMockUsers[phone] != password) {
      Get.snackbar(
        "Incorrect Password",
        "Please check your password and try again.",
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar("Login Successful", "Welcome back!");
    Get.toNamed('/home');
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
