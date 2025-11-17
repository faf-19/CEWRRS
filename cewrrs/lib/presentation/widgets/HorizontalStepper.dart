import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalStepper extends StatelessWidget {
  final StaffReportController controller = Get.find();
  final List<String> stepTitles;

  HorizontalStepper({required this.stepTitles, super.key});

  Widget _chip({
    required int index,
    required bool isActive,
    required bool showCheck,
    required VoidCallback onTap,
    required double chipWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: chipWidth, // Fixed width for perfect alignment
        height: chipWidth, // Make it square/circular
        decoration: BoxDecoration(
          color: isActive ? Appcolors.primary : Colors.grey.withOpacity(0.3),
          shape: BoxShape.circle,
          boxShadow: isActive ? [
            BoxShadow(
              color: Appcolors.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Center(
          child: showCheck
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _wire() {
    return Container(
      width: 50, // Length of the wire
      height: 2, // Thickness
      color: Appcolors.primary.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize MediaQuery ONCE
    final double screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      final int currentStep = controller.currentStep.value;
      final int totalSteps = stepTitles.length;
      final double spacing = 10; // Fixed spacing
      final double availableWidth = screenWidth - (spacing * (totalSteps + 1));
      final double chipWidth = (availableWidth / totalSteps).clamp(20, 40); // Fit the width, but limit size

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
            children: List.generate(totalSteps * 2 - 1, (index) {
              final int i = index ~/ 2;
              final bool isChip = index % 2 == 0;
              if (isChip) {
                final bool isPast = i < currentStep;
                final bool isActive = i <= currentStep;
                return _chip(
                  index: i,
                  isActive: isActive,
                  showCheck: isPast,
                  chipWidth: chipWidth,
                  onTap: () {
                    if (i <= currentStep) {
                      controller.currentStep.value = i;
                    }
                  },
                );
              } else {
                return _wire();
              }
            }),
          ),
        ),
      );
    });
  }
}
