import 'dart:io';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/upload_dilaog.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

class SendFileWidget extends StatefulWidget {
  final QuuickReportController reportController;
  const SendFileWidget({Key? key, required this.reportController});

  @override
  State<SendFileWidget> createState() => _SendFileWidgetState();
}

class _SendFileWidgetState extends State<SendFileWidget> {
  void _openFile(PlatformFile file) {
    // File opening functionality removed for simplicity
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _actionButton(
        icon: Iconsax.document,
        label: 'Upload Files',
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UploadDialog(
                onUpload: uploadfile,
                title: 'Upload Files',
                contentTexts: [
                  'Upload PDF or DOCX files',
                  'Maximum upload size: 20 MB.',
                  'Up to 5 files allowed',
                ],
              );
            },
          );
        },
        color: Colors.purple.shade50,
        iconColor: Colors.purple.shade700,
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
          border: Border.all(color: iconColor.withValues(alpha: .35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: iconColor.withValues(alpha: .25),
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
              style: TextStyle(
    fontFamily: 'Montserrat',
    
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void uploadfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      // Validate the file extension
      if (file.extension != null &&
          (file.extension == 'pdf' ||
          file.extension == 'doc' ||
          file.extension == 'docx')) {
        // Get the file size
        var fileSize = await File(file.path!).length();
        double fileSizeInMegabytes = fileSize / (1024 * 1024);

        // Validate the file size
        if (fileSizeInMegabytes <= 20) {
          // File is valid and within the size limit, proceed with processing
          setState(() {
            widget.reportController.selectedFile.add(file);
          });
          Get.snackbar("Success!", "File uploaded successfully");
        } else {
          Get.snackbar(
            "File Too Large!!",
            "Please select a file smaller than 20 MB",
          );
        }
      } else {
        Get.snackbar("Invalid File!!", "Please select a PDF or DOC file");
      }
    }
  }
}
