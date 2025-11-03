import 'dart:async';

import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
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
  int countdown = 30; // Start at 30 seconds
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startCountdown();

    // Auto-focus first OTP box after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void updateOtp(int index, String value) {
    final currentOtp = controller.otp.text.padRight(4, ' ');
    String newOtp;

    if (value.isEmpty) {
      newOtp = currentOtp.replaceRange(index, index + 1, ' ');
    } else {
      newOtp = currentOtp.replaceRange(index, index + 1, value);
    }

    controller.otp.text = newOtp.trim();

    // Auto-submit when 4 digits are entered
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
    for (var node in _focusNodes) {
      node.dispose();
    }
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
        Get.back(); // Close dialog
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
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Appcolors.textDark),
          onPressed: () => Get.offAllNamed('/intro'),
        ),
        title: Text(
          "Quick Report",
          style: AppTextStyles.heading.copyWith(color: Appcolors.textDark, fontSize: 16),
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
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24, // Push above keyboard
        ),
        child: Column(
          children: [
            // Main Card
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
                  Text(
                    "We texted you a code to verify your phone number\n(+251) ${controller.phone.text}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // OTP Input Boxes
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
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Appcolors.primary, width: 2),
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

                  // Resend / Countdown
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
                              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Text(
                            "Resend in $countdown sec",
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    "This code will expire 30 sec after this message. If you don't get a message.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 24),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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