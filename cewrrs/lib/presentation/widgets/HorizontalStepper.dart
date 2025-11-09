import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalStepper extends StatelessWidget {
  final StaffReportController controller = Get.find();
  final List<String> stepTitles;

  HorizontalStepper({required this.stepTitles, super.key});

  Widget _chip({
    required String title,
    required bool isActive,
    required bool showCheck,
    required VoidCallback onTap,
    required double chipWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: chipWidth, // Fixed width for perfect alignment
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? Appcolors.primary : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showCheck)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.check, size: 16, color: Colors.white),
              ),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery ONCE
    final double screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenWidth * 0.01; // As you requested
    final double chipWidth = screenWidth * 0.19; // Perfect ratio

    return Obx(() {
      final int currentStep = controller.currentStep.value;
      final int totalSteps = stepTitles.length;

      final double totalWidth =
          (chipWidth * totalSteps) + (spacing * (totalSteps + 1));

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 12,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Appcolors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalSteps, (i) {
              final bool isPast = i < currentStep;
              final bool isActive = i <= currentStep;

              return Padding(
                padding: EdgeInsets.only(
                  right: i < totalSteps - 1 ? spacing : 0,
                ),
                child: _chip(
                  title: stepTitles[i],
                  isActive: isActive,
                  showCheck: isPast,
                  chipWidth: chipWidth,
                  onTap: () {
                    if (i <= currentStep) {
                      controller.currentStep.value = i;
                    }
                  },
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
