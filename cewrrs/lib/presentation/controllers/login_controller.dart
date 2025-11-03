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
    '+2519111111': 'password123',
    '+251922334455': 'secret456',
  };

  final storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    // Listen to text changes to update form validity
    emailController.addListener(_checkFormValidity);
    passwordController.addListener(_checkFormValidity);
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
  String phone = emailController.text.trim();
  final password = passwordController.text;

  // Normalize local format to international
  if (phone.startsWith('09') && phone.length == 10) {
    phone = '+251' + phone.substring(1);
  }

  // Validate format
  if (!RegExp(r'^\+2519\d{8}$').hasMatch(phone)) {
    Get.snackbar("Invalid Phone", "Please enter a valid Ethiopian phone number.");
    return;
  }

  // Mock user check
  if (!mockUsers.containsKey(phone)) {
    Get.snackbar("User Not Found", "No account found for this phone number.");
    return;
  }

  if (mockUsers[phone] != password) {
    Get.snackbar("Incorrect Password", "Please check your password and try again.");
    return;
  }

  isLoading.value = true;
  await Future.delayed(const Duration(seconds: 2));
  isLoading.value = false;

  Get.snackbar("Login Successful", "Welcome back!");
  Get.toNamed('/home');
}
}
