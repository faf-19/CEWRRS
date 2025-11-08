import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  void register() {
    final phone = phoneController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (!RegExp(r'^\+?251\d{8}$').hasMatch(phone)) {
      Get.snackbar("Invalid Phone", "Please enter a valid Ethiopian phone number.");
      return;
    }

    if (password != confirm) {
      Get.snackbar("Password Mismatch", "Passwords do not match.");
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Account created for $username");
    });
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
