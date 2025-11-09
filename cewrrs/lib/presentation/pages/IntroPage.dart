import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/core/config/app_constants.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:cewrrs/presentation/controllers/language_controller.dart';
import 'package:cewrrs/presentation/widgets/language_selector.dart';

class IntroPage extends StatelessWidget {
  IntroPage({super.key});

  final langController = Get.find<LanguageController>();

  // NOTE: Screen dimensions MUST be defined inside the build method.
  // The incorrect lines have been removed from here.

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Define screen dimensions here where 'context' is available
    final size = MediaQuery.of(context).size;
    // final screenWidth = size.width;
    final screenHeight = size.height; // <-- This is your variable
    // Calculate a responsive height (e.g., 5% of the screen height)
    // Adjust the multiplier (0.05) to fine-tune the spacing.
    final responsiveSpacing = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),

          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
              child: Column(
                children: [
                  // Logo (Top Left)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.2),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 170,
                        height: 170,
                      ),
                    ),
                  ),

                  // **MODIFICATION START: Use responsive spacing**
                  SizedBox(height: screenHeight * 0.05),
                  // **MODIFICATION END**

                  // Centered Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.05,
                          ), // Keep this if you want some padding before the title text too

                          Text(
                            "Conflict Early Warning System",
                            style: AppTextStyles.heading,
  
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppConstants.sectionSpacing),
                          _buildButton(
                            label: "Quick Report",
                            // onPressed: () => Get.toNamed("/phone"),
                            onPressed: () => Get.toNamed("/report"),
                            bgColor: Appcolors.primary,
                            textColor: Appcolors.background,
                          ),
                          const SizedBox(height: AppConstants.fieldSpacing),
                          _buildButton(
                            label: "Login",
                            onPressed: () => Get.toNamed("/login"),
                            bgColor: Appcolors.background,
                            textColor: Appcolors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Language Selector (Bottom)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.bottomSpacing,
                    ),
                    child: LanguageSelector(langController: langController),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Button (Moved outside build, but inside the class)
  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color bgColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          side: BorderSide(color: textColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
