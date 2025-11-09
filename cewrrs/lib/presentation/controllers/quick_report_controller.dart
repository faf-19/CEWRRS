import 'dart:convert';
import 'dart:io';

import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class QuuickReportController extends GetxController {
  final HomeController homeController = Get.put(HomeController());

  final GlobalKey<FormState> descriptionformKey = GlobalKey<FormState>();

  var tabIndex = 0.obs;
  var showAll = true.obs;
  var selectedDay = 1.obs;
  var selectedMonth = 1.obs;
  var selectedYear = DateTime.now().year.obs;
  var selectedTime = TimeOfDay.now().obs;
  var contactInfo = ''.obs;

  List<String> ethiopianMonths = [
    'መስከረም',
    'ጥቅምት',
    'ሕዳር',
    'ታኅሣሥ',
    'ጥር',
    'የካቲት',
    'መጋቢት',
    'ሚያዝያ',
    'ግንቦት',
    'ሰኔ',
    'ሐምሌ',
    'ነሐሴ',
    'ጳጉሜ'
  ];

  Rx<DateTime> selectedDateTime = Rx<DateTime>(DateTime.now());
  RxBool isDateSelelcted = RxBool(false);

  late TextEditingController description;
  RxBool isToggled = false.obs;
  var isSendreport = false.obs;
  var isLoading = false.obs;
  bool isDraft = false;
  late String phonenumberCr = "";

  // Reports list
  // var reports = <Report>[].obs;

  //send image
  RxList<File> selectedImages = <File>[].obs;

  //Send video
  RxList<File> selectedVideos = <File>[].obs;

  RxList<File> selectedSignVideos = <File>[].obs;
  RxList<VideoPlayerController> videoControllers =
      <VideoPlayerController>[].obs;

  //send audio
  RxList<String> audioPaths = <String>[].obs;

  //Send link
  RxList<String> selectedLinks = <String>[].obs;

  //send file
  RxList<PlatformFile> selectedFile = <PlatformFile>[].obs;

  //locations
  double? latitude;
  double? longitude;
  bool isGettingLocation = false;
  double? targetLatitude = 8.9889820;
  double? targetlongitude = 38.7703300;
  Rx<LatLng> selectedLocation = LatLng(8.9889820, 38.7703300).obs;
  RxBool isLocationSelelcted = RxBool(false);

  late TabController tabController;

  final count = 0.obs;
  var selectedFilter = "All".obs;
  // var filteredReports = <Report>[].obs;
  List<String> get filters => ["All", "PENDING", "ACCEPTED"];

  @override
  void onInit() {
    description = TextEditingController();
    // ever(reports, (_) => applyFilter(selectedFilter.value));
    super.onInit();
  }

  // void applyFilter(String filter) {
  //   selectedFilter.value = filter;

  //   if (filter == "All") {
  //     filteredReports.assignAll(reports);
  //   } else {
  //     filteredReports.assignAll(reports
  //         .where(
  //             (report) => report.status.toUpperCase() == filter.toUpperCase())
  //         .toList());
  //   }
  // }

  void updateMarker(LatLng position) {
    if (position != null) {
      isLocationSelelcted(true);
      selectedLocation.value = position;
      //for the backend
      latitude = position.latitude;
      longitude = position.longitude;
      //save the lataes position
      targetLatitude = position.latitude;
      targetlongitude = position.longitude;
    } else {
      isLocationSelelcted(false);
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // Submit report method
  // Update the submitReport method in your ReportController
//   Future<void> submitReport() async {
//     if (!descriptionformKey.currentState!.validate()) {
//       Get.snackbar('Error', 'Please fill all required fields');
//       return;
//     }

//     if (!isLocationSelelcted.value) {
//       Get.snackbar('Error', 'Please select a location');
//       return;
//     }

//     if (!isDateSelelcted.value) {
//       Get.snackbar('Error', 'Please select incident time');
//       return;
//     }

//     // Validate that we

//     if (latitude == null || longitude == null) {
//       Get.snackbar('Error', 'Location data is missing');
//       return;
//     }

//     try {
//       isSendreport(true);
//       isLoading(true);

//       // Create report request WITHOUT attachments
//       final reportRequest = CreateReportRequest(
//         latitude: latitude!,
//         longitude: longitude!,
//         // phoneNumber: homeController.userPhoneNo.value,
//         phoneNumber: '0910111213',
//         description: description.text.isNotEmpty ? description.text : null,
//         incidentTime: selectedDateTime.value,
//       );

//       print('Submitting report: ${reportRequest.toJson()}'); // Debug log

//       // Send to API
//       final newReport = await reportService.createReport(reportRequest);

//       Get.snackbar('Success', 'Report submitted successfully',
//           backgroundColor: AppColors.success,
//           snackPosition: SnackPosition.BOTTOM);

//       // Clear form
//       clearForm();
//       await getReports();
//       // Optionally navigate to reports list
//       Get.to(() => ReportsListView());
//     } catch (e) {
//       print('Error submitting report: $e'); // Debug log
//       Get.snackbar('Error', 'Failed to submit report: $e');
//     } finally {
//       isSendreport(false);
//       isLoading(false);
//     }
//   }

//   // Get all reports
// // Update the getReports method in your ReportController
//   Future<void> getReports() async {
//     try {
//       isLoading(true);
//       print('Fetching reports...'); // Debug log
//       final reportsList = await reportService.getReports();
//       reports.assignAll(reportsList);
//        applyFilter(selectedFilter.value);
//       print('Fetched ${reportsList.length} reports'); // Debug log
//     } catch (e) {
//       print('Error fetching reports: $e'); // Debug log
//       Get.snackbar(
//         'Error',
//         'Failed to load reports: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

  // Clear form method
  void clearForm() {
    description.clear();
    selectedImages.clear();
    selectedVideos.clear();
    selectedSignVideos.clear();
    selectedLinks.clear();
    selectedFile.clear();
    isLocationSelelcted(false);
    isDateSelelcted(false);
    selectedDateTime.value = DateTime.now();
  }

  Future<ImageType> getImageType(File file) async {
    final String? mimeType = lookupMimeType(file.path);

    if (mimeType != null && mimeType.startsWith('image/')) {
      return ImageType.image;
    }

    if (mimeType != null && mimeType.startsWith('video/')) {
      return ImageType.video;
    }

    return ImageType.video;
  }

  Future<VideoType> getVideoType(File file) async {
    final String? mimeType = lookupMimeType(file.path);

    if (mimeType != null && mimeType.startsWith('video/')) {
      return VideoType.video;
    }

    if (mimeType != null && mimeType.startsWith('audio/')) {
      return VideoType.audio;
    }

    return VideoType.unknown;
  }
}

enum ImageType { image, video }

enum VideoType { video, image, audio, unknown }