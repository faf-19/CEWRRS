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
        await _validateAndAdd(image);
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
          await _validateAndAdd(img);
        }
      }
    } catch (e) {
      _snack('Gallery Error', 'Failed to pick images: $e');
    }
  }

  // ────── Validate & Add Image ──────
  Future<void> _validateAndAdd(XFile imageFile) async {
    const maxSize = 20 * 1024 * 1024; // 20 MB
    
    try {
      final file = File(imageFile.path);
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

      // Validate image type using the controller's method
      final type = await widget.reportController.getVideoType(imageFile);

      if (type != VideoType.image) {
        _snack('Invalid!', 'Please select a photo.');
        return;
      }

      if (widget.reportController.selectedImages.length >= 5) {
        _snack('Limit Reached', 'You can only add 5 photos.');
        return;
      }

      setState(() {
        widget.reportController.selectedImages.add(imageFile);
      });

      _snack('Success!', 'Photo added successfully.');
    } catch (e) {
      _snack('Error', 'Failed to validate image: $e');
    }
  }

  void _delete(int index) {
    setState(() {
      widget.reportController.selectedImages.removeAt(index);
    });
    _snack('Deleted', 'Photo removed.');
  }

  void _snack(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showPreview(File image, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(image, fit: BoxFit.contain),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _delete(index);
                    },
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _actionButton(
        icon: Iconsax.camera,
        label: 'Add Photos',
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => UploadDialog(
              title: 'Add Photos',
              contentTexts: [
                'Take photo with camera',
                'Choose from gallery',
                'Up to 5 photos',
                'Max 20 MB each',
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
}
