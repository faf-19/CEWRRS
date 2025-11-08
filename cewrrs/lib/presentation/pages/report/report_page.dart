import 'package:cewrrs/core/config/app_constants.dart';
import 'package:cewrrs/presentation/widgets/HorizontalStepper.dart';
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

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final ReportController controller;
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReportController());
    homeController = Get.find<HomeController>();
  }

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
        return StepReview();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: Obx(() {
          final currentStep = controller.currentStep.value;
          final isReviewStep = currentStep == 4;
          final isEditing = controller.isInEditMode.value && !isReviewStep;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stepper
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: HorizontalStepper(
                  stepTitles: const [
                    "Location",
                    "Timing",
                    "Details",
                    "Response",
                  ],
                ),
              ),

              // Content Area – Card for steps 0–3, Fullscreen for Review
              Expanded(
                child: isReviewStep
                    ? // REVIEW STEP: No card, full screen
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(4),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: _getCurrentStepWidget(currentStep),
                            key: ValueKey<int>(currentStep),
                          ),
                        ),
                      )
                    : // OTHER STEPS: Inside card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Appcolors.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Appcolors.primary.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Appcolors.primary.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              child: _getCurrentStepWidget(currentStep),
                              key: ValueKey<int>(currentStep),
                            ),
                          ),
                        ),
                      ),
              ),

              // Keyboard-aware bottom padding
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom + 20
                    : 20,
              ),

              // Navigation Buttons – Centered
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalPadding,
                  vertical: AppConstants.verticalPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // When editing from review: show Next and Done
                    if (isEditing) ...[
                      NeumorphicButton(
                        onPressed: () {
                          controller.nextStep();
                          if (controller.currentStep.value == 4) {
                            controller.isInEditMode.value = false;
                          }
                        },
                        style: NeumorphicStyle(
                          color: Colors.grey[100],
                          depth: 6,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Next",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      NeumorphicButton(
                        onPressed: controller.returnToReview,
                        style: NeumorphicStyle(
                          color: Appcolors.primary,
                          depth: 4,
                          intensity: 0.9,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Normal flow: Back (if >0) and Next/Submit
                      if (currentStep > 0)
                        NeumorphicButton(
                          onPressed: controller.previousStep,
                          style: NeumorphicStyle(
                            color: Colors.grey[100],
                            depth: 6,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.black54,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Back",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),

                      if (currentStep > 0) const SizedBox(width: 16),

                      NeumorphicButton(
                        onPressed: () {
                          if (currentStep < 4) {
                            controller.nextStep();
                          } else {
                            final isValid = controller.validateAndSubmit();
                            if (isValid) {
                              // Close any lingering snackbars shortly after submit
                              Get.closeAllSnackbars();
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  Get.closeAllSnackbars();
                                },
                              );
                              controller.showThankYouDialog();
                              controller.resetForm();
                            }
                          }
                        },
                        style: NeumorphicStyle(
                          color: Appcolors.primary,
                          depth: 4,
                          intensity: 0.9,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentStep < 4 ? "Next" : "Submit",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              currentStep < 4
                                  ? Icons.arrow_forward_ios
                                  : Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
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
