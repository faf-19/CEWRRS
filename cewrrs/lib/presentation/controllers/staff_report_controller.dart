import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../themes/colors.dart';

class StaffReportController extends GetxController {
  // -------------------------------------------------------------------------
  // 1. Stepper & Navigation
  // -------------------------------------------------------------------------
  final RxInt currentStep = 0.obs;
  final PageController pageController = PageController();

  bool get isLastStep => currentStep.value == 4;
  bool get isFirstStep => currentStep.value == 0;

  // -------------------------------------------------------------------------
  // 2. Edit / Expand helpers (now inside the class)
  // -------------------------------------------------------------------------
  final RxBool isInEditMode = false.obs;
  final RxMap<String, bool> expandedFields = <String, bool>{}.obs;

  // -------------------------------------------------------------------------
  // 3. Attachment
  // -------------------------------------------------------------------------
  final Rxn<XFile> selectedFile = Rxn<XFile>();
  final Rxn<Uint8List> selectedBytes = Rxn<Uint8List>();
  final RxBool hasAttachment = false.obs;

  // -------------------------------------------------------------------------
  // 4. Location data
  // -------------------------------------------------------------------------
  final RxList<String> regions = [
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

  final RxList<String> kebeles = ['1', '2', '3', '4', '5'].obs;
  final RxList<String> zones = ['Zone 1', 'Zone 2', 'Zone 3'].obs;
  final RxList<String> woredas = [
    'Woreda A',
    'Woreda B',
    'Woreda C',
    'Woreda D',
    'Woreda E',
  ].obs;

  final RxMap<String, List<String>> subCities = <String, List<String>>{
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
  // 5. Incident Details
  // -------------------------------------------------------------------------
  final RxList<String> incidentTypes = [
    'Conflict',
    'Displacement',
    'Protest',
    'Violence',
    'Other',
  ].obs;
  final RxnString selectedIncidentType = RxnString();

  final RxList<String> victims = [
    'Individual',
    'Group',
    'Community',
    'Institution',
  ].obs;
  final RxnString selectedVictim = RxnString();

  final RxList<String> causes = [
    'Political',
    'Ethnic',
    'Religious',
    'Criminal',
    'Unknown',
  ].obs;
  final RxnString selectedCause = RxnString();

  final RxList<String> levels = ['Local', 'Regional', 'National'].obs;
  final RxnString selectedLevel = RxnString();

  final RxList<String> contexts = [
    'Political',
    'Social',
    'Economic',
    'Environmental',
    'Other',
  ].obs;
  final RxnString selectedContext = RxnString();

  // -------------------------------------------------------------------------
  // 6. Response
  // -------------------------------------------------------------------------
  final RxList<String> responseTypes = [
    'Mediation',
    'Security Intervention',
    'Community Dialogue',
    'Other',
  ].obs;
  final RxnString selectedResponseType = RxnString();

  final Rxn<DateTime> responseDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> responseTime = Rxn<TimeOfDay>();
  final RxString responseReason = ''.obs;
  final RxString actionTaken = ''.obs;

  // -------------------------------------------------------------------------
  // 7. Core Form Fields
  // -------------------------------------------------------------------------
  final RxnString selectedRegion = RxnString();
  final RxnString selectedZone = RxnString();
  final RxnString selectedSubCity = RxnString();
  final RxnString selectedWoreda = RxnString();
  final RxnString selectedKebele = RxnString();

  final RxString description = ''.obs;
  final RxString placeName = ''.obs;

  final Rxn<DateTime> incidentDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> incidentTime = Rxn<TimeOfDay>();

  // -------------------------------------------------------------------------
  // 8. Navigation helpers
  // -------------------------------------------------------------------------
  void nextStep() {
    if (!validateCurrentStep()) return;

    // Submit on the Review step (index 4)
    if (currentStep.value == 4) {
      if (validateAndSubmit()) {
        showThankYouDialog();
        resetForm();
      }
      return;
    }

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
  // 9. Media Picker
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

      if (file == null) {
        hasAttachment.value = false;
        Get.snackbar(
          'Cancelled',
          'No file selected.',
          backgroundColor: Appcolors.accent,
          colorText: Appcolors.background,
        );
        return;
      }

      selectedFile.value = file;
      hasAttachment.value = true;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        selectedBytes.value = bytes;
      }

      Get.snackbar(
        'Success',
        'Attachment added',
        backgroundColor: Appcolors.primary,
        colorText: Appcolors.background,
      );
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
  // 10. Validation helpers
  // -------------------------------------------------------------------------
  void _showError(String message) {
    Get.snackbar(
      'Missing Info',
      message,
      backgroundColor: Appcolors.error,
      colorText: Appcolors.background,
      snackPosition: SnackPosition.TOP,
    );
  }

  bool _validateLocation() {
    if (selectedRegion.value == null) {
      _showError("Please select a Region/City");
      return false;
    }

    final bool isSpecial =
        selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final String? zoneOrSubCity = isSpecial
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
      _showError("Please select a Kebele");
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

  bool _validateDetails() {
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
    return true;
  }

  bool _validateResponse() {
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
  // 11. Step-by-step validation
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
        return _validateResponse();
      case 4: // Review – always valid
        return true;
      default:
        return true;
    }
  }

  // -------------------------------------------------------------------------
  // 12. Final submission validation
  // -------------------------------------------------------------------------
  bool validateAndSubmit() {
    return _validateLocation() &&
        _validateTiming() &&
        _validateDetails() &&
        _validateResponse();
  }

  // -------------------------------------------------------------------------
  // 13. Logging & UI helpers
  // -------------------------------------------------------------------------
  void _logReport() {
    final bool isSpecial =
        selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final String? zoneOrSubCity = isSpecial
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

  void showThankYouDialog({BuildContext? context}) {
    final BuildContext ctx = context ?? Get.context!;
    showDialog(
      context: ctx,
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

    // Auto-close after a short delay and go back to home
    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.canPop(ctx)) Navigator.of(ctx).pop();
      Get.offAllNamed('/home');
    });
  }

  // -------------------------------------------------------------------------
  // 14. Reset & Edit helpers
  // -------------------------------------------------------------------------
  void returnToReview() {
    isInEditMode.value = false;
    currentStep.value = 4; // Review step
    if (pageController.hasClients) pageController.jumpToPage(4);
  }

  void resetForm() {
    // Core fields
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
    placeName.value = '';

    selectedFile.value = null;
    selectedBytes.value = null;
    hasAttachment.value = false;

    selectedResponseType.value = null;
    responseDate.value = null;
    responseTime.value = null;
    responseReason.value = '';
    actionTaken.value = '';

    // UI state
    currentStep.value = 0;
    pageController.jumpToPage(0);
    expandedFields.clear();
    isInEditMode.value = false;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
