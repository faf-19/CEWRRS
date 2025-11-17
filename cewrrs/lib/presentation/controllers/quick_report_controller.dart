import 'dart:convert';
import 'dart:io';

import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

enum MediaType { image, video, audio, file, link, unknown }
enum VideoType { image, video, audio, unknown }

// Simple Report class for now
class Report {
  final String id;
  final String description;
  final DateTime timestamp;
  
  Report({
    required this.id,
    required this.description,
    required this.timestamp,
  });
}

class QuuickReportController extends GetxController {
  final HomeController homeController = Get.put(HomeController());

  final GlobalKey<FormState> descriptionformKey = GlobalKey<FormState>();
  final RxInt wordCount = 0.obs;

  var tabIndex = 0.obs;
  var showAll = true.obs;
  var selectedDay = 1.obs;

  // Time and Media
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  var description = ''.obs;

  // Location Management using latlong2
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();
  final RxBool isLocationSelelcted = false.obs;

  // Media Collections
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<XFile> selectedVideos = <XFile>[].obs;
  final RxList<XFile> selectedSignVideos = <XFile>[].obs;
  final RxList<String> audioPaths = <String>[].obs;
  final RxList<String> selectedLinks = <String>[].obs;
  final RxList<File> selectedFiles = <File>[].obs;

  // Other form data
  List selectedFile = [].obs;
  List selectedFilePaths = [].obs;
  var selectedFileName = ''.obs;
  var selectedFileSize = ''.obs;
  var base64String = ''.obs;
  var fileExtension = ''.obs;

  // Video player
  VideoPlayerController? videoFileController;
  var videoUrl = ''.obs;

  var reportType = 'General'.obs;

  var reportList = <Report>[].obs;

  bool isGettingLocation = false;
  double? targetLatitude = 8.9889820;
  double? targetlongitude = 38.7703300;

  late TabController tabController;

  final count = 0.obs;
  var selectedFilter = "All".obs;

  // Media type detection
  Future<VideoType> getVideoType(dynamic file) async {
    if (file is File) {
      final mimeType = lookupMimeType(file.path);
      if (mimeType == null) return VideoType.unknown;
      
      if (mimeType.startsWith('image/')) return VideoType.image;
      if (mimeType.startsWith('video/')) return VideoType.video;
      if (mimeType.startsWith('audio/')) return VideoType.audio;
      
      return VideoType.unknown;
    }
    return VideoType.unknown;
  }

  void updateMarker(LatLng position) {
    isLocationSelelcted(true);
    selectedLocation.value = position;
    //for the backend
    targetLatitude = position.latitude;
    targetlongitude = position.longitude;
    //save the latest position
    targetLatitude = position.latitude;
    targetlongitude = position.longitude;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // Add media methods
  void addImage(XFile image) {
    if (selectedImages.length < 5) {
      selectedImages.add(image);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void addVideo(XFile video, {bool isSignVideo = false}) {
    if (isSignVideo) {
      selectedSignVideos.add(video);
    } else {
      selectedVideos.add(video);
    }
  }

  void removeVideo(int index, {bool isSignVideo = false}) {
    if (isSignVideo) {
      if (index >= 0 && index < selectedSignVideos.length) {
        selectedSignVideos.removeAt(index);
      }
    } else {
      if (index >= 0 && index < selectedVideos.length) {
        selectedVideos.removeAt(index);
      }
    }
  }

  void addAudio(String audioPath) {
    audioPaths.add(audioPath);
  }

  void removeAudio(int index) {
    if (index >= 0 && index < audioPaths.length) {
      audioPaths.removeAt(index);
    }
  }

  void addLink(String link) {
    selectedLinks.add(link);
  }

  void removeLink(int index) {
    if (index >= 0 && index < selectedLinks.length) {
      selectedLinks.removeAt(index);
    }
  }

  void addFile(File file) {
    selectedFiles.add(file);
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  // Clear all data
  void clearAllData() {
    selectedImages.clear();
    selectedVideos.clear();
    selectedSignVideos.clear();
    audioPaths.clear();
    selectedLinks.clear();
    selectedFiles.clear();
    selectedFile.clear();
    selectedFilePaths.clear();
    selectedFileName.value = '';
    selectedFileSize.value = '';
    base64String.value = '';
    fileExtension.value = '';
    selectedLocation.value = null;
    isLocationSelelcted(false);
  }

  // Get all reports
  void getAllReports() {
    // Implementation for getting all reports
  }

  // Get filtered reports
  void getFilteredReports() {
    // Implementation for filtered reports
  }
}