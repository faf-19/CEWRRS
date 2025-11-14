import 'dart:io';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/upload_dilaog.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';

class SendFileWidget extends StatefulWidget {
  final QuuickReportController reportController;
  SendFileWidget({Key? key, required this.reportController});

  @override
  _SendFileWidgetState createState() => _SendFileWidgetState();
}

class _SendFileWidgetState extends State<SendFileWidget> {
  void _openFile(PlatformFile file) {
    // File opening functionality removed for simplicity
  }

  // URL input controller and category selection
  final TextEditingController urlController = TextEditingController();
  String selectedCategory = 'Others';
  final List<String> categories = ['Facebook', 'YouTube', 'TikTok', 'Others'];

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File Upload Section
          _actionButton(
            icon: Iconsax.document,
            label: 'Upload PDF/DOCX'.tr,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UploadDialog(
                    onUpload: uploadfile,
                    title: 'Upload Files'.tr,
                    contentTexts: [
                      'Upload PDF or DOCX files'.tr,
                      'Maximum upload size: 20 MB.'.tr,
                      'Up to 5 files allowed'.tr,
                    ],
                  );
                },
              );
            },
            color: Colors.purple.shade50,
            iconColor: Colors.purple.shade700,
          ),
          
          const SizedBox(height: 16),
          
          // Show uploaded files
          if (widget.reportController.selectedFile.isNotEmpty)
            Container(
              height: 120, // Reduced height
              child: ListView.builder(
                itemCount: widget.reportController.selectedFile.length,
                itemBuilder: (context, index) {
                  final file = widget.reportController.selectedFile[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        _getFileIcon(file.extension),
                        color: Colors.purple,
                      ),
                      title: Text(
                        file.name,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                        style: const TextStyle(fontSize: 10),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, size: 16),
                        onPressed: () => _deleteFile(index),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _deleteFile(int index) {
    setState(() {
      widget.reportController.selectedFile.removeAt(index);
    });
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
        } else {
          Get.snackbar(
            "File Too Large!!",
            "Please select a file smaller than 20 MB".tr,
          );
        }
      } else {
        Get.snackbar("Invalid File!!".tr, "Please select a PDF or DOC file".tr);
      }
    }
  }
}
