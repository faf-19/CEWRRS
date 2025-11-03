// step_review.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/report_controller.dart';
import '../../../themes/colors.dart';

class StepReview extends StatelessWidget {
  final ReportController controller = Get.find();

  StepReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ──────── 1. Incident Location ────────
            _section("Incident Location", [
              _item("Region/City", controller.selectedRegion.value),
              _item(
                "Zone/Sub‑City",
                controller.selectedZone.value ?? controller.selectedSubCity.value,
              ),
              _item("Woreda", controller.selectedWoreda.value),
              _item("Kebele", controller.selectedKebele.value),
            ]),

            const SizedBox(height: 16),

            // ──────── 2. Incident Timing ────────
            _section("Incident Timing", [
              _item("Type", controller.selectedIncidentType.value),
              _item(
                "Date",
                controller.incidentDate.value?.toLocal().toString().split(' ')[0],
              ),
              _item(
                "Time",
                controller.incidentTime.value?.format(context),
              ),
            ]),

            const SizedBox(height: 16),

            // ──────── 3. Incident Details ────────
            _section("Incident Details", [
              _item("Victim", controller.selectedVictim.value),
              _item("Cause", controller.selectedCause.value),
              _item("Level", controller.selectedLevel.value),
              _item("Context", controller.selectedContext.value),
            ]),

            const SizedBox(height: 16),

            // ──────── 4. Response ────────
            _section("Response", [
              _item("Type", controller.selectedResponseType.value),
              _item(
                "Date",
                controller.responseDate.value?.toLocal().toString().split(' ')[0],
              ),
              _item(
                "Time",
                controller.responseTime.value?.format(context),
              ),
              _item("Reason", controller.responseReason.value),
              _item("Action Taken", controller.actionTaken.value),
              _item(
                "Attachment",
                controller.selectedFile.value?.name ?? "None",
              ),
            ]),

            const SizedBox(height: 32),

            // ──────── Submit Button ────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final isValid = controller.validateAndSubmit();
                  if (isValid) {
                    controller.showThankYouAndRedirect(context);
                    controller.resetForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Appcolors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Submit Report",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Section title + children
  // ──────────────────────────────────────────────────────────────
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Appcolors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Label : Value row
  // ──────────────────────────────────────────────────────────────
  Widget _item(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Appcolors.textDark,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "—",
              style: const TextStyle(
                fontSize: 14,
                color: Appcolors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension ReportControllerExtras on ReportController {
  /// Provides a thank-you dialog (same style as quick_report_page) and a redirect
  void showThankYouAndRedirect(BuildContext context) {
    // Use the dialog method from the controller
    showThankYouDialog(context: context);
  }
}