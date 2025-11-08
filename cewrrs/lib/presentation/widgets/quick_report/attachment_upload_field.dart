import 'dart:io';
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentUploadField extends StatelessWidget {
  const AttachmentUploadField({super.key, required this.controller});

  final QuickReportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final file = controller.selectedFile.value;
      final hasFile = controller.hasAttachment.value;
      final isValidSize = controller.fileSizeValid.value;

      return Column(
        children: [
          GestureDetector(
            onTap: controller.pickMedia,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Appcolors.fieldFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasFile
                      ? (isValidSize ? Appcolors.primary : Colors.red.shade400)
                      : Colors.grey.shade300,
                  width: hasFile ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  if (file != null && !kIsWeb)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(file.path),
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (file != null &&
                      kIsWeb &&
                      controller.selectedBytes.value != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        controller.selectedBytes.value!,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  if (file != null) const SizedBox(height: 8),

                  Icon(
                    hasFile
                        ? (isValidSize ? Icons.check_circle : Icons.error)
                        : Icons.cloud_upload_outlined,
                    size: 32,
                    color: hasFile
                        ? (isValidSize
                              ? Appcolors.primary
                              : Colors.red.shade400)
                        : Appcolors.primary,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    hasFile
                        ? (isValidSize
                              ? "Attached – Tap to change"
                              : "File too large (>10 MB)")
                        : "Tap to attach photo/video *",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: hasFile
                          ? (isValidSize
                                ? Appcolors.primary
                                : Colors.red.shade700)
                          : Appcolors.textDark,
                      fontWeight: hasFile ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (hasFile && !isValidSize)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Please select a file smaller than 10 MB.",
                style: TextStyle(fontSize: 12, color: Colors.red.shade600),
              ),
            ),
        ],
      );
    });
  }
}
