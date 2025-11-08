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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ──────── 1. Incident Location ────────
            _sectionWithEdit(
              title: "Incident Location",
              stepIndex: 0,
              children: [
                _item("Region/City", controller.selectedRegion.value),
                _item(
                  "Zone/Sub-City",
                  controller.selectedZone.value ??
                      controller.selectedSubCity.value,
                ),
                _item("Woreda", controller.selectedWoreda.value),
                _item("Kebele", controller.selectedKebele.value),
                _expandableItem(
                  "Specific Place",
                  controller.placeName.value,
                  maxLines: 2,
                ),
              ],
            ),

            _divider(),

            // ──────── 2. Incident Timing ────────
            _sectionWithEdit(
              title: "Incident Timing",
              stepIndex: 1,
              children: [
                _item("Type", controller.selectedIncidentType.value),
                _item(
                  "Date",
                  controller.incidentDate.value?.toLocal().toString().split(
                    ' ',
                  )[0],
                ),
                _item("Time", controller.incidentTime.value?.format(context)),
              ],
            ),

            _divider(),

            // ──────── 3. Incident Details ────────
            _sectionWithEdit(
              title: "Incident Details",
              stepIndex: 2,
              children: [
                _item("Victim", controller.selectedVictim.value),
                _item("Cause", controller.selectedCause.value),
                _item("Level", controller.selectedLevel.value),
                _expandableItem(
                  "Context",
                  controller.selectedContext.value,
                  maxLines: 3,
                ),
              ],
            ),

            _divider(),

            // ──────── 4. Response ────────
            _sectionWithEdit(
              title: "Response",
              stepIndex: 3,
              children: [
                _item("Type", controller.selectedResponseType.value),
                _item(
                  "Date",
                  controller.responseDate.value?.toLocal().toString().split(
                    ' ',
                  )[0],
                ),
                _item("Time", controller.responseTime.value?.format(context)),
                _expandableItem(
                  "Reason",
                  controller.responseReason.value,
                  maxLines: 3,
                ),
                _expandableItem(
                  "Action Taken",
                  controller.actionTaken.value,
                  maxLines: 4,
                ),
                _item(
                  "Attachment",
                  controller.selectedFile.value?.name ?? "None",
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Section with Edit Icon
  // ──────────────────────────────────────────────────────────────
  Widget _sectionWithEdit({
    required String title,
    required int stepIndex,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textDark,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.isInEditMode.value = true;
                controller.currentStep.value = stepIndex;
                if (controller.pageController.hasClients) {
                  controller.pageController.jumpToPage(stepIndex);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Appcolors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Appcolors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Normal Item
  // ──────────────────────────────────────────────────────────────
  Widget _item(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
              value?.isNotEmpty == true ? value! : "—",
              style: const TextStyle(fontSize: 14, color: Appcolors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Expandable Item with "Read More"
  // ──────────────────────────────────────────────────────────────
  Widget _expandableItem(String label, String? text, {int maxLines = 2}) {
    if (text == null || text.isEmpty) {
      return _item(label, "—");
    }

    return Obx(() {
      final bool isExpanded = controller.expandedFields["$label"] ?? false;
      final bool hasMore = text.length > 60; // or use line count

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    maxLines: isExpanded ? 20 : maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Appcolors.textDark,
                    ),
                  ),
                  if (hasMore)
                    GestureDetector(
                      onTap: () {
                        controller.expandedFields["$label"] = !isExpanded;
                      },
                      child: Text(
                        isExpanded ? "Read Less" : "Read More",
                        style: TextStyle(
                          color: Appcolors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Divider
  // ──────────────────────────────────────────────────────────────
  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey, thickness: 1),
    );
  }
}
