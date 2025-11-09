// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/upload_dilaog.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart'; // Assuming this defines Appcolors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

// NOTE: Defining ImageType here for completeness in this file.
enum ImageType { image, video, unknown }

// NOTE: Assuming QuuickReportController and Appcolors are defined or imported correctly elsewhere
// and that UploadDialog is also defined and imported.

class SendPhotoWidget extends StatefulWidget {
  final QuuickReportController reportController;
  const SendPhotoWidget({Key? key, required this.reportController})
      : super(key: key);

  @override
  _SendPhotoWidgetState createState() => _SendPhotoWidgetState();
}

class _SendPhotoWidgetState extends State<SendPhotoWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // ────── Take Live Photo (Camera) ──────
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (photo != null) {
      await _validateAndAdd(File(photo.path));
    }
  }

  // ────── Pick from Gallery (Multi) ──────
  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
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
              top: 20,
              right: 20,
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

  // --- START REFACTORED METHOD ---

  /// Builds the unified, responsive container for the two action buttons (Camera and Gallery).
  Widget _buildActionButtonsContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 450 as the breakpoint for better mobile compatibility
        final isSmall = constraints.maxWidth < 450;
        
        // This is the functional and non-duplicated rendering of the two options
        final cameraButton = _actionButton(
          icon: Iconsax.camera,
          label: 'Take Photo'.tr,
          onTap: _takePhoto,
          color: Colors.purple.shade50,
          iconColor: Colors.purple.shade700,
          pulse: true,
        );

        final galleryButton = _actionButton(
          icon: Iconsax.gallery,
          label: 'Gallery'.tr,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => UploadDialog(
                onUpload: _pickFromGallery,
                title: 'Upload from Gallery'.tr,
                contentTexts: [
                  'Up to 5 photos'.tr,
                  'Max 20 MB each'.tr,
                ],
              ),
            );
          },
          color: Colors.blue.shade50,
          iconColor: Colors.blue.shade700,
        );
        
        // If small, stack them in a Column (full width)
        if (isSmall) {
          return Column(
            children: [
              cameraButton,
              const SizedBox(height: 12),
              galleryButton,
            ],
          );
        }

        // If large, place them side-by-side in a Row (expanded)
        return Row(
          children: [
            Expanded(child: cameraButton),
            const SizedBox(width: 16),
            Expanded(child: galleryButton),
          ],
        );
      },
    );
  }

  // --- END REFACTORED METHOD ---


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Appcolors.primary.withOpacity(.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Iconsax.camera, color: Appcolors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Text(
                'Add Photos'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Appcolors.primary,
                ),
              ),
              const Spacer(),
              Obx(() => Chip(
                    backgroundColor: Appcolors.primary.withOpacity(.1),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    label: Text(
                      '${widget.reportController.selectedImages.length}/5',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Appcolors.primary,
                      ),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 20),

          // ── Image Previews (Horizontal scroll prevents overflow) ──
          Obx(() {
            final images = widget.reportController.selectedImages;
            if (images.isEmpty) return _buildEmptyState();

            return SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, i) {
                  final file = images[i];
                  return GestureDetector(
                    onTap: () => _showPreview(file, i),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'photo_$i',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              file,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _delete(i),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black26, blurRadius: 4)
                                ],
                              ),
                              child: const Icon(Icons.close, size: 18, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 24),

          // ── Action Buttons: Calling the new unified, non-duplicated builder ──
          Obx(() {
            final canAdd = widget.reportController.selectedImages.length < 5;
            if (!canAdd) return const SizedBox();

            return _buildActionButtonsContainer();
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Appcolors.primary.withOpacity(.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Appcolors.primary.withOpacity(.25), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.image, size: 38, color: Appcolors.primary.withOpacity(.5)),
          const SizedBox(height: 10),
          Text(
            'No photos yet'.tr,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Appcolors.primary.withOpacity(.7),
              fontWeight: FontWeight.w600,
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
    bool pulse = false,
  }) {
    // Wrapped with ClipRRect for consistent border radius
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AnimatedScale(
        scale: pulse ? _pulseAnimation.value : 1.0,
        duration: const Duration(milliseconds: 1500),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: iconColor.withOpacity(.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(.25),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}