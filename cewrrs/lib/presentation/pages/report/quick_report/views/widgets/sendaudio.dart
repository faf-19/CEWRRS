// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/upload_dilaog.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class SendaudioWidget extends StatefulWidget {
  final QuuickReportController reportController;
  SendaudioWidget({Key? key, required this.reportController});

  @override
  _SendaudioWidgetState createState() => _SendaudioWidgetState();
}

class _SendaudioWidgetState extends State<SendaudioWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ────── File Picker ──────
  void _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.first.path!);
      const maxSize = 5 * 1024 * 1024; // 5MB

      if (file.lengthSync() <= maxSize) {
        final type = await widget.reportController.getVideoType(file);
        if (type == VideoType.audio) {
          setState(() => widget.reportController.audioPaths.add(file.path));
        } else {
          Get.snackbar("Invalid File", "Please select valid audio");
        }
      } else {
        Get.snackbar("Too Large", "File must be under 5MB");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _actionButton(
        icon: Iconsax.microphone,
        label: 'Upload Audio'.tr,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => UploadDialog(
              onUpload: _pickAudioFile,
              title: 'Upload Audio'.tr,
              contentTexts: ['Upload up to 5 files'.tr, 'Max 5MB'.tr],
            ),
          );
        },
        color: Colors.orange.shade50,
        iconColor: Colors.orange.shade700,
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: iconColor.withOpacity(.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: iconColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
