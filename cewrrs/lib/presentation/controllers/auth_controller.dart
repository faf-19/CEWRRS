import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final phone = TextEditingController();
  final otp = TextEditingController();
  final RxBool _isOtpVerified = false.obs;


  void sendOtp() {
    if (phone.text.isEmpty || phone.text.length < 10) {
      Get.snackbar("Invalid", "Please enter a valid phone number");
      return;
    }

    // Simulate sending OTP
    Future.delayed(const Duration(seconds: 1), () {
      Get.toNamed('/verify');
    });
  }
  bool get isOtpVerified => _isOtpVerified.value;

  void verifyOtp() {
    if (otp.text == "1234") {
      Get.snackbar("Success", "Phone verified");
  _isOtpVerified.value = true; // ✅ mark as verified
      } else {
      Get.snackbar("Error", "Invalid OTP");
    }
  }

}
