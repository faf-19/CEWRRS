import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class QuickReportController extends GetxController {
  // ──────────────────────────────────────────────────────────────
  // Attachment
  // ──────────────────────────────────────────────────────────────
  final Rxn<XFile> selectedFile = Rxn<XFile>();
  final hasAttachment = false.obs;
  final selectedBytes = Rxn<Uint8List>();

  // ──────────────────────────────────────────────────────────────
  // Location data
  // ──────────────────────────────────────────────────────────────
  final regions = [
    'Addis Ababa',
    'Dire Dawa',
    'Afar',
    'Amhara',
    'Benishangul-Gumuz',
    'Central Ethiopia',
    'Gambela',
    'Harari',
    'Oromia',
    'Sidama',
    'Somali',
    'South Ethiopia',
    'Southwest Ethiopia Peoples',
    'Tigray',
  ].obs;

  final zones = <String>[
    'zone 1'
    'zone 2'
  ].obs; // Fill dynamically if needed

  final woredas = <String>[
    'Woreda A',
    'Woreda B',
    'Woreda C',
    'Woreda D',
    'Woreda E',
  ].obs;

  final subCities = <String, List<String>>{
    'Addis Ababa': [
      'Addis Ketema',
      'Akaky Kaliti',
      'Arada',
      'Bole',
      'Gullele',
      'Kirkos',
      'Kolfe Keranio',
      'Lideta',
      'Nifas Silk-Lafto',
      'Yeka',
    ],
    'Dire Dawa': [
      'Abuna',
      'Adiga',
      'Gende Kore',
    ],
  }.obs;

  // ──────────────────────────────────────────────────────────────
  // Form fields
  // ──────────────────────────────────────────────────────────────
  final selectedRegion = RxnString();
  final selectedZone = RxnString();
  final selectedSubCity = RxnString();
  final selectedWoreda = RxnString();

  final kebele = ''.obs;
  final description = ''.obs;

  // ──────────────────────────────────────────────────────────────
  // Pick Media (Gallery or Camera)
  // ──────────────────────────────────────────────────────────────
Future<void> pickMedia() async {
  final picker = ImagePicker();

  await showModalBottomSheet(
    context: Get.context!,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.blue),
            title: const Text("Choose from Gallery"),
            onTap: () async {
              Navigator.pop(Get.context!);
              await _pickFromSource(picker, ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.green),
            title: const Text("Take a Photo"),
            onTap: () async {
              Navigator.pop(Get.context!);
              await _pickFromSource(picker, ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.red),
            title: const Text("Cancel"),
            onTap: () => Navigator.pop(Get.context!),
          ),
        ],
      ),
    ),
  );
}


  Future<void> _pickFromSource(ImagePicker picker, ImageSource source) async {
    try {
      final XFile? file = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (file != null) {
        selectedFile.value = file;
        hasAttachment.value = true;
        Get.snackbar(
          'Success',
          'Attachment added: ${file.name}',
          backgroundColor: Appcolors.primary,
          colorText: Appcolors.background,
        );
      } else {
        hasAttachment.value = false;
        Get.snackbar(
          'Cancelled',
          'No file selected.',
          backgroundColor: Appcolors.accent,
          colorText: Appcolors.background,
        );
      }
    } catch (e) {
      hasAttachment.value = false;
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Appcolors.error,
        colorText: Appcolors.background,
      );
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Submit Report – returns true if valid
  // ──────────────────────────────────────────────────────────────
  bool validateAndSubmit() {
    if (selectedRegion.value == null) {
      _showError("Please select a Region/City");
      return false;
    }

    final isSpecial = selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final zoneOrSubCity = isSpecial ? selectedSubCity.value : selectedZone.value;

    if (zoneOrSubCity == null) {
      _showError(
          "Please select ${isSpecial ? 'a Sub-City' : 'a Zone'}");
      return false;
    }

    if (selectedWoreda.value == null) {
      _showError("Please select a Woreda");
      return false;
    }

    if (kebele.value.trim().isEmpty) {
      _showError("Please enter Kebele");
      return false;
    }

    if (description.value.trim().isEmpty) {
      _showError("Please enter a description");
      return false;
    }

    if (!hasAttachment.value) {
      _showError("Please attach a picture or video");
      return false;
    }

    // ─── SUCCESS: All required fields filled ───
    _logReport();
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Missing Info',
      message,
      backgroundColor: Appcolors.error,
      colorText: Appcolors.background,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _logReport() {
    final isSpecial = selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final zoneOrSubCity = isSpecial ? selectedSubCity.value : selectedZone.value;

    print("=== QUICK REPORT SUBMITTED ===");
    print("Region: ${selectedRegion.value}");
    print("Zone/Sub-City: $zoneOrSubCity");
    print("Woreda: ${selectedWoreda.value}");
    print("Kebele: ${kebele.value}");
    print("Description: ${description.value}");
    print("Attachment: ${selectedFile.value?.path}");
    print("===============================");
  }

  // ──────────────────────────────────────────────────────────────
  // Reset form after successful submission
  // ──────────────────────────────────────────────────────────────
  void resetForm() {
    selectedRegion.value = null;
    selectedZone.value = null;
    selectedSubCity.value = null;
    selectedWoreda.value = null;
    kebele.value = '';
    description.value = '';
    selectedFile.value = null;
    hasAttachment.value = false;
  }
}