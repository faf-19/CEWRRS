import 'package:cewrrs/core/config/app_constants.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/login_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';

class LoginPage extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final screenWidth = size.width;
    final screenHeight = size.height; // <-- This is your variable

    // Define a reusable input border for a consistent look
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Appcolors.textDark,
          ),
          onPressed: () => Get.offAllNamed('/intro'), // ✅ Always go to home
        ),
        title: Text(
          "",
          style: AppTextStyles.heading.copyWith(
            color: Appcolors.primary,
            fontSize: 16,
            fontFamily: "Montserrat",
          ),
        ),
        // actions: [ ... ],
      ),
      backgroundColor: Appcolors.background,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
              vertical: AppConstants.verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🛑 FIX APPLIED HERE:
                // 1. Changed 'ScreenHeight' to 'screenHeight'.
                // 2. Removed 'const' keyword.
                SizedBox(
                  height: screenHeight * 0.15,
                ), // Adjusted height to 15% to avoid large blank space
                // and prevent potential overflow on smaller screens.

                // Logo
                Center(
                  child: Image.asset('assets/images/logo.png', height: 80),
                ),
                const SizedBox(height: 22),

                // Header
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Appcolors.primary,
                    fontFamily: "Montserrat",
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  "Sign in to your account",
                  style: TextStyle(
                    fontSize: 16,
                    color: Appcolors.textLight,
                    fontFamily: "Montserrat",
                  ),
                ),

                const SizedBox(height: 30),

                // Email (Phone Number)
                TextField(
                  controller: controller.emailController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "phone Number",
                    prefixIcon: const Icon(Icons.phone),
                    counterText: '', // Hide character counter
                    // Use a filled decoration for visibility since borderSide is none
                    filled: true,
                    fillColor: Appcolors
                        .fieldFill, // Assuming you have a light color for field fill
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(
                        color: Appcolors.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      // Submit when Enter is pressed if form is valid
                      if (controller.isFormValid.value &&
                          !controller.isLoading.value) {
                        controller.login();
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          controller.isPasswordVisible.value =
                              !controller.isPasswordVisible.value;
                        },
                      ),
                      // Use a filled decoration for visibility since borderSide is none
                      filled: true,
                      fillColor: Appcolors.fieldFill,
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorder.copyWith(
                        borderSide: BorderSide(
                          color: Appcolors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                Obx(
                  () => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                controller.isFormValid.value &&
                                    !controller.isLoading.value
                                ? () {
                                    controller.login();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isFormValid.value
                                  ? Appcolors.primary
                                  : Colors.grey.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: controller.isFormValid.value ? 3 : 0,
                            ),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Appcolors.primary),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Up Link (usually placed here)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Get.toNamed('/register'),
                    child: const Text(
                      "Create Account",
                      style: TextStyle(color: Appcolors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
