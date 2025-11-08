// ignore_for_file: library_private_types_in_public_api
import 'dart:io';
import 'package:e_carta_app/app/modules/report/controllers/report_controller.dart';
import 'package:e_carta_app/app/modules/report/views/widgets/upload_dilaog.dart';
import 'package:e_carta_app/config/theme/app_colors.dart';
import 'package:e_carta_app/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class SendVideoWidget extends StatefulWidget {
  final ReportController reportController;
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
  TextEditingController textEditingController = TextEditingController();
  XFile? image;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  final picker = ImagePicker();

  Future<void> _getFromGallery() async {
    final int maxSizeInBytes = 50 * 1024 * 1024; // 50 MB
    final List<XFile>? videos = await picker.pickMultipleMedia();
    if (videos != null) {
      for (var video in videos) {
        File file = File(video.path);
        // Check if the file exists
        if (await file.exists()) {
          // Get the file size
          int fileSize = await file.length();
          // If the file size is greater than the max size, show error and return
          if (fileSize > maxSizeInBytes) {
            Get.snackbar(
              "Invalid File!!".tr,
              "Please select a Video file less than 50 MB".tr,
            );
            return; // Stop further processing
          }
          // If the file size is less than or equal to the max size, proceed
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1),
          Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Video Upload'.tr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Appcolors.primary,
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(height: 0.5, color: Colors.grey),
                  widget.reportController.selectedVideos.isNotEmpty
                      ? getVideo()
                      : widget.reportController.selectedSignVideos.isNotEmpty
                      ? getSignVideo()
                      : SizedBox(height: 5),
                  SizedBox(height: 5),
                  widget.reportController.selectedVideos.length < 2
                      ? getFrom()
                      : widget.reportController.selectedSignVideos.length < 2
                      ? getFromSign()
                      : const SizedBox(),
                  SizedBox(height: 5),
                  Container(height: 0.5, color: Colors.grey),
                ],
              ),
            ),
          ),
          //Description
          //contact me
        ],
      ),
    );
  }

  void _showVideoInPopup(File videoFile) {
    final videoController = VideoPlayerController.file(videoFile);
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
                    child: FutureBuilder(
                      future: videoController.initialize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // Play the video after initialization
                          videoController.play();
                          return AspectRatio(
                            aspectRatio: videoController.value.aspectRatio,
                            child: VideoPlayer(videoController),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
                    videoController.pause(); // Pause the video
                    videoController
                        .dispose(); // Dispose the controller when the dialog is closed
                  },
                  child: Text(
                    'Close'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getVideo() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.reportController.selectedVideos.length,
        itemBuilder: (BuildContext context, int index) {
          final videoFile = widget.reportController.selectedVideos[index];
          // Check if a VideoPlayerController instance already exists for this index
          if (index >= widget.reportController.videoControllers.length) {
            // Create a new VideoPlayerController instance
            final videoPlayerController = VideoPlayerController.file(videoFile);
            widget.reportController.videoControllers.add(videoPlayerController);
          } else {
            // Dispose the existing VideoPlayerController instance
            final oldController =
                widget.reportController.videoControllers[index];
            oldController.dispose();
            // Create a new VideoPlayerController instance with the updated file
            final newController = VideoPlayerController.file(videoFile);
            widget.reportController.videoControllers[index] = newController;
          }
          final videoPlayerController =
              widget.reportController.videoControllers[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => _showVideoInPopup(videoFile),
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FutureBuilder(
                        future: videoPlayerController.initialize(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: 80,
                                height: 90,
                                child: AspectRatio(
                                  aspectRatio:
                                      videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        deleteVideo(index);
                      },
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getSignVideo() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.reportController.selectedSignVideos.length,
        itemBuilder: (BuildContext context, int index) {
          final videoFile = widget.reportController.selectedSignVideos[index];
          // Check if a VideoPlayerController instance already exists for this index
          if (index >= widget.reportController.videoControllers.length) {
            // Create a new VideoPlayerController instance
            final videoPlayerController = VideoPlayerController.file(videoFile);
            widget.reportController.videoControllers.add(videoPlayerController);
          } else {
            // Dispose the existing VideoPlayerController instance
            final oldController =
                widget.reportController.videoControllers[index];
            oldController.dispose();
            // Create a new VideoPlayerController instance with the updated file
            final newController = VideoPlayerController.file(videoFile);
            widget.reportController.videoControllers[index] = newController;
          }
          final videoPlayerController =
              widget.reportController.videoControllers[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => _showVideoInPopup(videoFile),
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FutureBuilder(
                        future: videoPlayerController.initialize(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: 80,
                                height: 90,
                                child: AspectRatio(
                                  aspectRatio:
                                      videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () => deleteVideo(index),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getFrom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UploadDialog(
                  onUpload: _getFromGallery,
                  title: 'Upload Video'.tr,
                  contentTexts: [
                    'You can upload 2 Video files'.tr,
                    'Maximum upload size: 50 MB.'.tr,
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
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Gallery'.tr,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Appcolors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Iconsax.image, color: Appcolors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getFromSign() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            _getFromGallery();
          },
          child: Row(
            children: [
              Text(
                'Gallery'.tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Appcolors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Iconsax.image, color: Appcolors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
