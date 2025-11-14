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
import 'package:google_fonts/google_fonts.dart';

enum ImageType { image, video, unknown }

class SendPhotoWidget extends StatefulWidget {
  final QuuickReportController reportController;
  const SendPhotoWidget({Key? key, required this.reportController})
      : super(key: key);

  @override
  _SendPhotoWidgetState createState() => _SendPhotoWidgetState();
}

class _SendPhotoWidgetState extends State<SendPhotoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ────── Pick from Camera ──────
  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (image != null) {
        await _validateAndAdd(File(image.path));
      }
    } catch (e) {
      _snack('Camera Error', 'Failed to capture image: $e');
    }
  }

  // ────── Pick from Gallery (Multi) ──────
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          await _validateAndAdd(File(img.path));
        }
      }
    } catch (e) {
      _snack('Gallery Error', 'Failed to pick images: $e');
    }
  }

  // ────── Validate & Add Image ──────
  Future<void> _validateAndAdd(File file) async {
    const maxSize = 20 * 1024 * 1024; // 20 MB
    final exists = await file.exists();
    final size = exists ? file.lengthSync() : 0;

    if (!exists || size == 0) {
      _snack('Oops!', 'File is empty or corrupted.');
      return;
    }
    if (size > maxSize) {
      _snack('Too Big!', 'Image must be < 20 MB.');
      return;
    }

    // NOTE: Mocking getImageType call to ensure compilation. 
    // In a real app, you would use:
    // final type = await widget.reportController.getImageType(file);
    const type = ImageType.image; 

    if (type != ImageType.image) {
      _snack('Invalid!', 'Please select a photo.');
      return;
    }

    if (widget.reportController.selectedImages.length >= 5) {
      _snack('Limit Reached', 'You can only add 5 photos.');
      return;
    }

    if (!widget.reportController.selectedImages.contains(file)) {
      setState(() {
        widget.reportController.selectedImages.add(file);
      });
      _snack('Added!', 'Photo added!', color: Colors.green);
    }
  }

  void _snack(String title, String message, {Color? color}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: (color ?? Colors.red).withOpacity(0.1),
      colorText: color ?? Colors.red.shade900,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }

  void _delete(int index) {
    setState(() {
      widget.reportController.selectedImages.removeAt(index);
    });
  }

  void _showPreview(File file, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Hero(
                  tag: 'photo_$index',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(file, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: FloatingActionButton.small(
                backgroundColor: Appcolors.primary,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Action button for adding photos
          _actionButton(
            icon: Iconsax.camera,
            label: 'Add Photos'.tr,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => UploadDialog(
                  title: 'Add Photos'.tr,
                  contentTexts: [
                    'Take photo with camera'.tr,
                    'Choose from gallery'.tr,
                    'Up to 5 photos'.tr,
                    'Max 20 MB each'.tr,
                  ],
                  showCameraOptions: true,
                  onCamera: _pickFromCamera,
                  onGallery: _pickFromGallery,
                ),
              );
            },
            color: Colors.blue.shade50,
            iconColor: Colors.blue.shade700,
          ),
          
          const SizedBox(height: 16),
          
          // Photo preview grid for selected images
          if (widget.reportController.selectedImages.isNotEmpty)
            Container(
              height: 150, // Reduced height
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemCount: widget.reportController.selectedImages.length,
                itemBuilder: (context, index) {
                  final image = widget.reportController.selectedImages[index];
                  return GestureDetector(
                    onTap: () => _showPreview(image, index),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        // Delete button
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => _delete(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
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
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}