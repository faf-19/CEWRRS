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

class SendPhotoWidget extends StatefulWidget {
  final QuuickReportController reportController;
  SendPhotoWidget({Key? key, required this.reportController}) : super(key: key);

  @override
  _SendPhotoWidgetState createState() => _SendPhotoWidgetState();
}

class _SendPhotoWidgetState extends State<SendPhotoWidget> {
  TextEditingController textEditingController = TextEditingController();
  XFile? image;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> _getFromGallery() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      for (var image in images) {
        final File file = File(image.path);
        final int maxSizeInBytes = 20 * 1024 * 1024; // 20 MB
        if (await file.exists() && file.lengthSync() <= maxSizeInBytes) {
          final imageType = await widget.reportController.getImageType(file);
          if (imageType == ImageType.image) {
            setState(() {
              widget.reportController.selectedImages.add(file);
            });
          } else {
            // Show dialog if the selected file is not an image
            Get.snackbar("Invalid File!!".tr, "Please select an image.".tr);
          }
        } else {
          // Show dialog if the file is empty or exceeds 5 MB
          Get.snackbar(
            "Invalid File!!".tr,
            "Please select a non-empty image file less than 20 MB".tr,
          );
        }
      }
    }
  }

  void deleteImage(int index) {
    setState(() {
      widget.reportController.selectedImages.removeAt(index);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Photo Upload'.tr,
                  style: AppTextStyles.button.copyWith(
                    color: Appcolors.primary,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 1),
                Container(height: 0.5, color: Colors.grey),
                widget.reportController.selectedImages.isNotEmpty
                    ? SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              widget.reportController.selectedImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final image =
                                widget.reportController.selectedImages[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () => _showImageInPopup(image),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                        width: 80,
                                        height: 80,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => deleteImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(height: 8),
                SizedBox(height: 2),
                widget.reportController.selectedImages.length < 5
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return UploadDialog(
                                    onUpload: _getFromGallery,
                                    title: 'Upload Photos'.tr,
                                    contentTexts: [
                                      'You can upload 5 Photo files'.tr,
                                      'Maximum upload size: 20 MB.'.tr,
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                      0,
                                      3,
                                    ), // changes the position of the shadow
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Gallery'.tr,
                                    style: AppTextStyles.button.copyWith(
                                      color: Appcolors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Iconsax.image,
                                    color: Appcolors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: 7),
                Container(height: 0.5, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageInPopup(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Image.file(image, fit: BoxFit.contain),
                  ),
                ],
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolors.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text(
                    'Close'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
