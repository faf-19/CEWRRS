import 'dart:io';
import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';

class StepResponse extends StatelessWidget {
  final StaffReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // 🐛 FIX: Wrap the Column in SingleChildScrollView to prevent overflow.
    return SingleChildScrollView(
      padding: EdgeInsets
          .zero, // Padding is handled by the parent ReportPage container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Appcolors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Appcolors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_alarm,
                      color: Appcolors.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Response Detail",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Please provide the exact location where the incident occurred. ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 42),

          // Incident description is required on final submit
          _textField(
            "Incident Description",
            controller.description,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _uploadField(),
          const SizedBox(height: 16),
          _textField("Reason for Response", controller.responseReason),
          const SizedBox(height: 16),
          _textField(
            "Action Taken (Details)",
            controller.actionTaken,
            maxLines: 4,
          ),

          // Added space at the bottom to ensure the last text field is above the navigation buttons.
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, RxnString selected) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: selected.value,
        decoration: InputDecoration(
          //labelText: label,
          filled: true,
          fillColor: Appcolors.fieldFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }

  Widget _textField(String label, RxString value, {int maxLines = 1}) {
    return Obx(() {
      return TextFormField(
        initialValue: value.value,
        onChanged: (v) => value.value = v,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Appcolors.fieldFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    });
  }

  Widget _uploadField() {
    return Obx(() {
      final file = controller.selectedFile.value;
      final hasFile = controller.hasAttachment.value;

      return GestureDetector(
        onTap: controller.pickMedia,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Appcolors.fieldFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFile ? Appcolors.primary : Colors.grey.shade300,
              width: hasFile ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              if (file != null && !kIsWeb) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(file.path),
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ] else if (file != null &&
                  kIsWeb &&
                  controller.selectedBytes.value != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    controller.selectedBytes.value!,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Icon(
                hasFile ? Icons.check_circle : Icons.cloud_upload_outlined,
                size: 32,
                color: Appcolors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                hasFile
                    ? "Tap to change attachment"
                    : "Click to Snap or Upload a Picture/Video",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: hasFile ? Appcolors.primary : Appcolors.textDark,
                  fontWeight: hasFile ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
