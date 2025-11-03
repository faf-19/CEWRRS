import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../themes/colors.dart';

class ReportController extends GetxController {
  // -------------------------------------------------------------------------
  // 1. Stepper & Navigation
  // -------------------------------------------------------------------------
  final RxInt currentStep = 0.obs;
  final PageController pageController = PageController();
  bool get isLastStep => currentStep.value == 4;
  bool get isFirstStep => currentStep.value == 0;

  void nextStep() {
    // 🛑 Validate current step before proceeding
    if (!validateCurrentStep()) return;

    // ✅ If we are on the Review step (index 4), submit instead of advancing
    if (currentStep.value == 4) {
      final isValid = validateAndSubmit();
      if (isValid) {
        showThankYouDialog();
        resetForm();
      }
      return;
    }

    // ▶️ Otherwise, advance to the next step
    if (currentStep.value < 4) {
      currentStep.value++;
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentStep.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  // -------------------------------------------------------------------------
  // 2. Attachment
  // -------------------------------------------------------------------------
  final Rxn<XFile> selectedFile = Rxn<XFile>();
  final Rxn<Uint8List> selectedBytes = Rxn<Uint8List>();
  final hasAttachment = false.obs;

  // -------------------------------------------------------------------------
  // 3. Location data
  // -------------------------------------------------------------------------
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
  final Kebeles = ['1', '2', '3', '4', '5'].obs;

  final zones = ['Zone 1', 'Zone 2', 'Zone 3'].obs;
  final woredas = [
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
    'Dire Dawa': ['Abuna', 'Adiga', 'Gende Kore'],
  }.obs;

  // -------------------------------------------------------------------------
  // 4. Incident Details
  // -------------------------------------------------------------------------
  final incidentTypes = [
    'Conflict',
    'Displacement',
    'Protest',
    'Violence',
    'Other',
  ].obs;
  final selectedIncidentType = RxnString();

  final victims = ['Individual', 'Group', 'Community', 'Institution'].obs;
  final selectedVictim = RxnString();

  final causes = [
    'Political',
    'Ethnic',
    'Religious',
    'Criminal',
    'Unknown',
  ].obs;
  final selectedCause = RxnString();

  final levels = ['Local', 'Regional', 'National'].obs;
  final selectedLevel = RxnString();

  final contexts = [
    'Political',
    'Social',
    'Economic',
    'Environmental',
    'Other',
  ].obs;
  final selectedContext = RxnString();

  // -------------------------------------------------------------------------
  // 5. Response
  // -------------------------------------------------------------------------
  final responseTypes = [
    'Mediation',
    'Security Intervention',
    'Community Dialogue',
    'Other',
  ].obs;
  final selectedResponseType = RxnString();

  final responseDate = Rxn<DateTime>();
  final responseTime = Rxn<TimeOfDay>();
  final responseReason = ''.obs;
  final actionTaken = ''.obs;

  // -------------------------------------------------------------------------
  // 6. Core Form Fields
  // -------------------------------------------------------------------------
  final selectedRegion = RxnString();
  final selectedZone = RxnString();
  final selectedSubCity = RxnString();
  final selectedWoreda = RxnString();
  final selectedKebele = RxnString();

  final description = ''.obs;
  final placeName = ''.obs;

  final incidentDate = Rxn<DateTime>();
  final incidentTime = Rxn<TimeOfDay>();

  // -------------------------------------------------------------------------
  // 7. Media Picker (Camera/Gallery)
  // -------------------------------------------------------------------------
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

        if (kIsWeb) {
          final bytes = await file.readAsBytes();
          selectedBytes.value = bytes;
        }

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

  // -------------------------------------------------------------------------
  // 8. Validation Helpers
  // -------------------------------------------------------------------------

  bool _validateLocation() {
    if (selectedRegion.value == null) {
      _showError("Please select a Region/City");
      return false;
    }

    final isSpecial =
        selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final zoneOrSubCity = isSpecial
        ? selectedSubCity.value
        : selectedZone.value;

    if (zoneOrSubCity == null) {
      _showError("Please select ${isSpecial ? 'a Sub-City' : 'a Zone'}");
      return false;
    }

    if (selectedWoreda.value == null) {
      _showError("Please select a Woreda");
      return false;
    }

    if (selectedKebele.value == null) {
      _showError("Please enter Kebele");
      return false;
    }

    return true;
  }

  bool _validateTiming() {
    if (selectedIncidentType.value == null) {
      _showError("Please select Incident Type");
      return false;
    }
    if (incidentDate.value == null) {
      _showError("Please select Incident Date");
      return false;
    }
    if (incidentTime.value == null) {
      _showError("Please select Incident Time");
      return false;
    }
    return true;
  }

  bool _validateDetails() {
    if (selectedVictim.value == null) {
      _showError("Please select Victim");
      return false;
    }
    if (selectedCause.value == null) {
      _showError("Please select Cause");
      return false;
    }
    if (selectedLevel.value == null) {
      _showError("Please select Incident Level");
      return false;
    }
    if (selectedContext.value == null) {
      _showError("Please select Incident Context");
      return false;
    }
    return true;
  }

  bool _validateDescriptionAndAttachment() {
    if (description.value.trim().isEmpty) {
      _showError("Please enter a description");
      return false;
    }
    if (!hasAttachment.value) {
      _showError("Please attach a picture or video");
      return false;
    }
    return true;
  }

  // NOTE: Renamed to avoid duplicate function definition.
  bool _validateResponseStep() {
    if (selectedResponseType.value == null) {
      _showError("Please select Response Type");
      return false;
    }
    if (responseDate.value == null) {
      _showError("Please select Response Date");
      return false;
    }
    if (responseTime.value == null) {
      _showError("Please select Response Time");
      return false;
    }
    if (responseReason.value.trim().isEmpty) {
      _showError("Please enter Reason for Response");
      return false;
    }
    if (actionTaken.value.trim().isEmpty) {
      _showError("Please enter Action Taken");
      return false;
    }
    return true;
  }

  // -------------------------------------------------------------------------
  // 9. Core Step-by-Step Validation (Implemented)
  // -------------------------------------------------------------------------

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        return _validateLocation();
      case 1:
        return _validateTiming();
      case 2:
        return _validateDetails();
      case 3:
        // Step 3 in UI is Response
        return _validateResponseStep();
      case 4:
        // Step 4 is Review/Preview – no validation needed here
        return true;
      case 5:
        // NEW: Preview page. No specific validation needed, just allow next (submit)
        return true; // Step 4 leads to final submission
      default:
        return true;
    }
  }

  // -------------------------------------------------------------------------
  // 10. Final Submission Validation
  // -------------------------------------------------------------------------
  bool validateAndSubmit() {
    // 💡 For a final submit, you should check ALL previous steps' validation,
    // in case the user jumped or logic was bypassed.

    // Step 0: Location
    if (!_validateLocation()) return false;

    // Step 1: Timing
    if (!_validateTiming()) return false;

    // Step 2: Details
    if (!_validateDetails()) return false;

    // Step 3: Description & Attachment
    if (!_validateDescriptionAndAttachment()) return false;

    // Step 4: Response
    if (!_validateResponseStep()) return false;

    // Everything is valid, log the report and submit
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
    final isSpecial =
        selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final zoneOrSubCity = isSpecial
        ? selectedSubCity.value
        : selectedZone.value;

    debugPrint("=== REPORT SUBMITTED ===");
    debugPrint("Region: ${selectedRegion.value}");
    debugPrint("Zone/Sub-City: $zoneOrSubCity");
    debugPrint("Woreda: ${selectedWoreda.value}");
    debugPrint("Kebele: ${selectedKebele.value}");
    debugPrint("Incident Type: ${selectedIncidentType.value}");
    debugPrint("Incident Date: ${incidentDate.value}");
    debugPrint("Incident Time: ${incidentTime.value}");
    debugPrint("Victim: ${selectedVictim.value}");
    debugPrint("Cause: ${selectedCause.value}");
    debugPrint("Level: ${selectedLevel.value}");
    debugPrint("Context: ${selectedContext.value}");
    debugPrint("Description: ${description.value}");
    debugPrint("Attachment: ${selectedFile.value?.path}");
    debugPrint("Response Type: ${selectedResponseType.value}");
    debugPrint("Response Date: ${responseDate.value}");
    debugPrint("Response Time: ${responseTime.value}");
    debugPrint("Response Reason: ${responseReason.value}");
    debugPrint("Action Taken: ${actionTaken.value}");
    debugPrint("===============================");
  }

  // -------------------------------------------------------------------------
  // 11. Show Thank You Dialog (similar to quick_report_page)
  // -------------------------------------------------------------------------
  void showThankYouDialog({BuildContext? context}) {
    final dialogContext = context ?? Get.context!;
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Appcolors.primary,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Ministry of Peace",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Thank you for sharing!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Your report has been submitted successfully.\nTogether, we build peace.",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (Get.isDialogOpen == true) {
        Get.back(); // Close dialog
      }
      // Optionally navigate to home or another page
      // Get.offAllNamed('/home');
    });
  }

  // -------------------------------------------------------------------------
  // 12. Reset Form
  // -------------------------------------------------------------------------
  void resetForm() {
    selectedRegion.value = null;
    selectedZone.value = null;
    selectedSubCity.value = null;
    selectedWoreda.value = null;
    selectedKebele.value = null;
    selectedIncidentType.value = null;
    incidentDate.value = null;
    incidentTime.value = null;
    selectedVictim.value = null;
    selectedCause.value = null;
    selectedLevel.value = null;
    selectedContext.value = null;
    description.value = '';
    selectedFile.value = null;
    selectedBytes.value = null;
    hasAttachment.value = false;
    selectedResponseType.value = null;
    responseDate.value = null;
    responseTime.value = null;
    responseReason.value = '';
    actionTaken.value = '';
    currentStep.value = 0;
    pageController.jumpToPage(0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
