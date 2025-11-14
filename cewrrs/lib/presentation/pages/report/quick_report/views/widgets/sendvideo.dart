// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/upload_dilaog.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class SendVideoWidget extends StatefulWidget {
  final QuuickReportController reportController;
  final bool isSignLangauge;
  SendVideoWidget({
    Key? key,
    required this.reportController,
    required this.isSignLangauge,
  }) : super(key: key);

  @override
  _SendVideowidgetState createState() => _SendVideowidgetState();
}

class _SendVideowidgetState extends State<SendVideoWidget> {
  final picker = ImagePicker();

  Future<void> _getFromGallery() async {
    final int maxSizeInBytes = 50 * 1024 * 1024; // 50 MB
    final List<XFile>? videos = await picker.pickMultipleMedia();
    if (videos != null) {
      for (var video in videos) {
        await _processVideo(File(video.path), maxSizeInBytes);
      }
    }
  }

  // ────── Pick from Camera ──────
  Future<void> _getFromCamera() async {
    final int maxSizeInBytes = 50 * 1024 * 1024; // 50 MB
    try {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2), // Limit to 2 minutes
      );
      if (video != null) {
        await _processVideo(File(video.path), maxSizeInBytes);
      }
    } catch (e) {
      Get.snackbar(
        "Camera Error".tr,
        "Failed to capture video: $e".tr,
      );
    }
  }

  // ────── Process Video ──────
  Future<void> _processVideo(File file, int maxSizeInBytes) async {
    if (await file.exists()) {
      int fileSize = await file.length();
      if (fileSize > maxSizeInBytes) {
        Get.snackbar(
          "Invalid File!!".tr,
          "Please select a Video file less than 50 MB".tr,
        );
        return;
      }
      if (fileSize <= maxSizeInBytes) {
        final videoType = await widget.reportController.getVideoType(file);
        if (videoType == VideoType.video) {
          setState(() {
            if (!widget.isSignLangauge) {
              widget.reportController.selectedVideos.add(file);
            } else {
              widget.reportController.selectedSignVideos.add(file);
            }
          });
        } else {
          Get.snackbar("Invalid File!!".tr, "Please select a Video.".tr);
        }
      }
    } else {
      print("File does not exist");
    }
  }

  void deleteVideo(int index) {
    if (!widget.isSignLangauge) {
      widget.reportController.selectedVideos.removeAt(index);
    } else {
      widget.reportController.selectedSignVideos.removeAt(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _actionButton(
        icon: Iconsax.video,
        label: 'Add Videos'.tr,
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UploadDialog(
                title: 'Add Videos'.tr,
                contentTexts: [
                  'Record video with camera'.tr,
                  'Choose from gallery'.tr,
                  'You can upload 2 Video files'.tr,
                  'Maximum upload size: 50 MB.'.tr,
                ],
                showCameraOptions: true,
                onCamera: _getFromCamera,
                onGallery: _getFromGallery,
              );
            },
          );
        },
        color: Colors.green.shade50,
        iconColor: Colors.green.shade700,
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
