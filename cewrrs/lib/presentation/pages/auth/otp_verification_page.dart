import 'dart:async';

import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final controller = Get.find<AuthController>();
  int countdown = 30;
  late Timer timer;

  // NEW: Clean +251 format (removes leading 0)
  String get _prettyPhone {
    final digits = controller.phone.text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0') && digits.length == 10) {
      final clean = '251${digits.substring(1)}';
      return '+251 ${clean.substring(3, 6)} ${clean.substring(6, 9)} ${clean.substring(9)}';
    }
    return controller.phone.text; // fallback
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void updateOtp(int index, String value) {
    final currentOtp = controller.otp.text.padRight(4, ' ');
    final newOtp = value.isEmpty
        ? currentOtp.replaceRange(index, index + 1, ' ')
        : currentOtp.replaceRange(index, index + 1, value);

    controller.otp.text = newOtp.trim();

    if (controller.otp.text.length == 4) {
      _verifyAndProceed();
    }
  }

  void _verifyAndProceed() async {
    controller.verifyOtp();
    if (controller.isOtpVerified) {
      showThankYouAndRedirect();
    }
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown > 1) {
        setState(() => countdown--);
      } else {
        t.cancel();
        setState(() => countdown = 0);
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  void showThankYouAndRedirect() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Appcolors.primary,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Ministry of Peace",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Icon(Icons.verified, color: Colors.white, size: 48),
              const SizedBox(height: 8),
              const Text(
                "Your phone number has been successfully verified.",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Get.back();
        Get.offAllNamed('/quick-report');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Appcolors.textDark,
          ),
          onPressed: () => Get.offAllNamed('/intro'),
        ),
        title: Text(
          "Quick Report",
          style: AppTextStyles.heading.copyWith(
            color: Appcolors.textDark,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset('assets/images/logo.png', width: 32, height: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 76,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Type a code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // FIXED: Now uses _prettyPhone → no more "0"!
                  Text(
                    "We have sent a secure verification code to your phone number.\n"
                    "Please enter it below to continue.\n $_prettyPhone",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // OTP Boxes (unchanged)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Appcolors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            updateOtp(index, value);
                            if (value.isNotEmpty && index < 3) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: countdown == 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                countdown = 30;
                                startCountdown();
                              });
                              controller.sendOtp();
                            },
                            child: const Text(
                              "Resend",
                              style: TextStyle(
                                color: Appcolors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Text(
                            "Resend in $countdown sec",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "This code will expire 30 sec after this message. If you don't get a message.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
