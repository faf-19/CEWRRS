import 'package:cewrrs/presentation/controllers/report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalStepper extends StatelessWidget {
  final ReportController controller = Get.find();
  final List<String> stepTitles;

  HorizontalStepper({required this.stepTitles, super.key});

  Widget _chip({
    required String title,
    required bool showCheck,
    required VoidCallback onTap,
    required double maxWidth,
  }) {
    return GestureDetector(
      
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Appcolors.primary,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCheck) ...[
                const Icon(Icons.check, size: 14, color: Colors.white),
                const SizedBox(height: 12,),
              ],
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

    return Obx(() {
      final int currentStep = controller.currentStep.value;

      final int total = stepTitles.length;
      final int visibleCount = (currentStep + 1).clamp(1, total);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Appcolors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double chipSpacing = (constraints.maxWidth * 0.04).clamp(6.0, 10.0);
            double tailWidth = 36; // trailing capsule target width
            double available = constraints.maxWidth - tailWidth - chipSpacing;
            if (available < 0) {
              // Hide tail when space is tight
              tailWidth = 0;
              available = constraints.maxWidth;
            }
            final double maxPerChip = (available - chipSpacing * (visibleCount - 1)) / visibleCount;
            final double chipMax = maxPerChip.isFinite
                ? maxPerChip.clamp(56.0, 150.0)
                : 100.0;

            return Row(
              children: [
                for (int i = 0; i < visibleCount; i++) ...[
                  _chip(
                    title: stepTitles[i],
                    showCheck: true,
                    maxWidth: chipMax,
                    onTap: () {
                      if (i <= currentStep) controller.currentStep.value = i;
                    },
                  ),
                  if (i < visibleCount - 1) SizedBox(width: chipSpacing),
                ],
                // no trailing capsule for preview step
              ],
            );
          },
        ),
      );
    });
  }
}