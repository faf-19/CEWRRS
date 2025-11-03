import 'package:cewrrs/core/config/app_constants.dart';
import 'package:cewrrs/presentation/widgets/HorizontalStepper.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/report_controller.dart';
import '../../themes/colors.dart';
import 'steps/step_location.dart';
import 'steps/step_timing.dart';
import 'steps/step_details.dart';
import 'steps/step_response.dart';
import 'steps/step_review.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ReportPage extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());

  ReportPage({super.key});

  // Helper function to return the correct step widget
  Widget _getCurrentStepWidget(int step) {
    switch (step) {
      case 0:
        return StepLocation();
      case 1:
        return StepTiming();
      case 2:
        return StepDetails();
      case 3:
        return StepResponse();
      case 4:
        // Assuming StepReview is the last step before submission/final review
        return StepReview(); 
      default:
        return Container(); // Should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return Scaffold(
    //  appBar: CustomAppbar(controller: homeController),
      resizeToAvoidBottomInset: true,
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: Obx(() {
          // Get the current step value once outside the build
          final currentStep = controller.currentStep.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🌟 Step Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: HorizontalStepper(
                  stepTitles: [
                    "Location",
                    "Timing",
                    "Details",
                    "Response",
                  ],
                )

              ),

              // 🧩 Step Content Card - Uses AnimatedSwitcher to manage the step content
              Expanded(
                child: Container( // No longer needs to be wrapped by AnimatedSwitcher
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Appcolors.background, // light gray box
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Appcolors.primary.withOpacity(0.5), // border color
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Appcolors.primary.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    // Use the current step value as the key for the AnimatedSwitcher
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: _getCurrentStepWidget(currentStep),
                    ), 
                    key: ValueKey<int>(currentStep),
                  ),
                ),
              ),

              // 🔘 Navigation Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding, vertical: AppConstants.verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentStep > 0)
                      NeumorphicButton(
                        onPressed: controller.previousStep,
                        style: NeumorphicStyle(
                          color: Colors.grey[100],
                          depth: 6,
                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back, color: Colors.black54, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Back",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (currentStep == 0) const Spacer(),

                    if (currentStep < 4)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: NeumorphicButton(
                            onPressed: controller.nextStep,
                            style: NeumorphicStyle(
                              color: Appcolors.primary,
                              depth: 3,
                              intensity: 0.9,
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}