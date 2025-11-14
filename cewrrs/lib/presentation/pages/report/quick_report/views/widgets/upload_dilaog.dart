// ignore_for_file: must_be_immutable
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDialog extends StatelessWidget {
  final VoidCallback? onUpload;
  final String title;
  final List<String> contentTexts;
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  bool? isAudo = false;
  final bool showCameraOptions;

  UploadDialog({
    this.onUpload,
    required this.title,
    required this.contentTexts,
    this.isAudo,
    this.onCamera,
    this.onGallery,
    this.showCameraOptions = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      content: showCameraOptions && (onCamera != null || onGallery != null)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Camera and Gallery options
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionButton(
                        context,
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.of(context).pop();
                          onCamera?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildOptionButton(
                        context,
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        color: Colors.green,
                        onTap: () {
                          Navigator.of(context).pop();
                          onGallery?.call();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Content texts
                Column(
                  children: contentTexts.map((text) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.circle, color: Appcolors.primary, size: 8),
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
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: contentTexts.map((text) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: const Icon(Icons.circle, color: Appcolors.primary, size: 8),
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
      actions: showCameraOptions && (onCamera != null || onGallery != null)
          ? null
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
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
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolors.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onUpload?.call();
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

  Widget _buildOptionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
