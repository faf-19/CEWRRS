// ignore_for_file: must_be_immutable
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDialog extends StatelessWidget {
  final VoidCallback onUpload;
  final String title;
  final List<String> contentTexts;
  bool? isAudo = false;

  UploadDialog({
    required this.onUpload,
    required this.title,
    required this.contentTexts,
    this.isAudo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: contentTexts.map((text) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 4,
            ), // Adjust the padding as needed
            child: ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: Icon(Icons.circle, color: Appcolors.primary, size: 8),
              title: Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: Appcolors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      actions: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the buttons horizontally
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
              ),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel'.tr,
                style: AppTextStyles.button.copyWith(
                  color: Appcolors.border,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(width: 8), // Add spacing between the buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appcolors.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onUpload(); // Call the provided callback function
              },
              child: Text(
                isAudo == true ? "Start Recording".tr : 'Upload'.tr,
                style: AppTextStyles.button.copyWith(
                  color: Appcolors.border,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
