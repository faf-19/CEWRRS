import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/glass_field.dart';
import '../../themes/colors.dart';
import '../../themes/text_style.dart';

class PhoneInputPage extends GetView<AuthController> {
  const PhoneInputPage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    
    return Scaffold(
      // The resizeToAvoidBottomInset property is set to true by default, 
      // which is usually enough, but we need the SingleChildScrollView.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Appcolors.textDark),
          onPressed: () => Get.offAllNamed('/intro'), // ✅ Always go to home
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
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: 
      // 🔑 THE FIX: Wrap the body content in a SingleChildScrollView
      SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Increased padding for better aesthetic
          child: Column(
            // NOTE: Use MainAxisAlignment.start or remove it, and add spacing to the top
            // to center the content visually, but let it scroll when the keyboard is up.
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              // Add vertical spacing based on screen height to push content down
              SizedBox(height: screenHeight * 0.2), 
              
              // Heading outside the box
              Text(
                "WELCOME TO CONFLICT \n EARLY WARNING \nREPORTING",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 32),

              // Card box with input and button
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlassField(
                        controller: controller.phone,
                        label: "Enter phone number",
                        icon: Icons.phone,
                        hint: "+251912345678",
                        maxLength: 10,
                        suffixIcon: const Icon(Icons.phone, color: Colors.blue),
                      ),
                      
                      // Using a fixed height for spacing here is often safer
                      const SizedBox(height: 32), 
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Proceed",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // Recommended for contrast
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Add some space at the bottom to ensure the card can scroll up fully
              SizedBox(height: screenHeight * 0.1), 
            ],
          ),
        ),
      ),
    );
  }
}
