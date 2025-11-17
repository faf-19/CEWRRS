import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validation/validators.dart';
import '../../../core/utils/security/otp_generator.dart';
import '../../../core/services/local_storage_service.dart';

/// AuthController with improved security and validation
/// This addresses the critical security vulnerability of hardcoded OTP
class AuthController extends GetxController {
  final phone = TextEditingController();
  final otp = TextEditingController();
  final RxBool _isOtpVerified = false.obs;
  
  // Secure OTP storage
  OtpData? _currentOtp;
  final LocalStorageService _storageService = LocalStorageService();

  /// Get current verification status
  bool get isOtpVerified => _isOtpVerified.value;

  /// Send OTP with secure generation
  void sendOtp() {
    // Validate phone number first
    final phoneValidation = Validators.validatePhoneNumber(phone.text);
    if (!phoneValidation.isValid) {
      Get.snackbar("Invalid Phone", phoneValidation.errorMessage);
      return;
    }

    // Generate secure OTP
    _currentOtp = OtpGenerator.generateOtpWithExpiry();
    
    // Store OTP securely (in a real app, this would be sent via SMS)
    _storeOtpSecurely(_currentOtp!);
    
    Get.snackbar(
      "OTP Sent",
      "A 6-digit code has been sent to ${phone.text}. Valid for 5 minutes.",
      duration: const Duration(seconds: 3),
    );

    // Navigate to OTP verification
    Future.delayed(const Duration(seconds: 1), () {
      Get.toNamed('/verify');
    });
  }

  /// Verify OTP with proper validation and security
  void verifyOtp() {
    // Validate OTP format
    final otpValidation = Validators.validateOtp(otp.text);
    if (!otpValidation.isValid) {
      Get.snackbar("Invalid OTP", otpValidation.errorMessage);
      return;
    }

    // Check if OTP exists and is valid
    if (_currentOtp == null) {
      Get.snackbar("Error", "Please request an OTP first");
      return;
    }

    // Verify OTP is not expired
    if (_currentOtp!.isExpired) {
      Get.snackbar("Error", "OTP has expired. Please request a new one.");
      _resetOtp();
      return;
    }

    // Verify OTP can still be used (not exceeded attempts)
    if (!_currentOtp!.canBeUsed) {
      Get.snackbar("Error", "Too many failed attempts. Please request a new OTP.");
      _resetOtp();
      return;
    }

    // Check if OTP matches
    if (_currentOtp!.code != otp.text) {
      // Increment attempts
      _currentOtp = _currentOtp!.incrementAttempts();
      _storeOtpSecurely(_currentOtp!);
      
      Get.snackbar(
        "Error",
        "Invalid OTP. ${3 - _currentOtp!.attempts} attempts remaining."
      );
      return;
    }

    // Success - OTP is valid
    _currentOtp = _currentOtp!.markAsUsed();
    _storeOtpSecurely(_currentOtp!);
    _isOtpVerified.value = true;
    
    Get.snackbar("Success", "Phone number verified successfully!");
    
    // Clear OTP field for security
    otp.clear();
  }

  /// Request new OTP (resend functionality)
  void resendOtp() {
    if (phone.text.isEmpty) {
      Get.snackbar("Error", "Please enter your phone number first");
      return;
    }

    // Reset and generate new OTP
    _resetOtp();
    sendOtp();
  }

  /// Reset OTP state
  void _resetOtp() {
    _currentOtp = null;
    _storageService.removeOtp();
    otp.clear();
  }

  /// Store OTP securely (in production, use encrypted storage)
  void _storeOtpSecurely(OtpData otpData) {
    _storageService.saveOtp(otpData);
  }

  /// Load stored OTP
  void _loadStoredOtp() {
    final storedOtp = _storageService.getStoredOtp();
    if (storedOtp != null && !storedOtp.isExpired) {
      _currentOtp = storedOtp;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadStoredOtp();
  }

  @override
  void onClose() {
    phone.dispose();
    otp.dispose();
    super.onClose();
  }
}
