import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/validation/validators.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../data/models/report_model.dart';
import '../themes/colors.dart';

/// StaffReportController with enhanced security and validation
/// This controller handles staff emergency reporting with improved code quality
class StaffReportController extends GetxController {
  // -------------------------------------------------------------------------
  // 1. Dependencies and Services
  // -------------------------------------------------------------------------
  final LocalStorageService _storageService = LocalStorageService();
  
  // -------------------------------------------------------------------------
  // 2. Stepper & Navigation
  // -------------------------------------------------------------------------
  final RxInt currentStep = 0.obs;
  final PageController pageController = PageController();

  /// Check if current step is the last step
  bool get isLastStep => currentStep.value == 4;
  
  /// Check if current step is the first step
  bool get isFirstStep => currentStep.value == 0;

  // -------------------------------------------------------------------------
  // 3. Edit / Expand helpers
  // -------------------------------------------------------------------------
  final RxBool isInEditMode = false.obs;
  final RxMap<String, bool> expandedFields = <String, bool>{}.obs;

  // -------------------------------------------------------------------------
  // 4. Attachment Management
  // -------------------------------------------------------------------------
  final Rxn<XFile> selectedFile = Rxn<XFile>();
  final Rxn<Uint8List> selectedBytes = Rxn<Uint8List>();
  final RxBool hasAttachment = false.obs;

  // -------------------------------------------------------------------------
  // 5. Location Data (Ethiopian Administrative Divisions)
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

  /// Ethiopian administrative subdivisions
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
  // 6. Incident Details - Dropdown Options
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
  // 7. Response Information
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
  // 8. Core Form Fields
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
  // 9. Location Management (using latlong2 for Flutter Map)
  // -------------------------------------------------------------------------
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();
  final RxBool isLocationSelelcted = false.obs;

  // -------------------------------------------------------------------------
  // 10. Navigation and Step Management
  // -------------------------------------------------------------------------
  
  /// Navigate to next step with validation
  void nextStep() {
    if (!validateCurrentStep()) return;

    // Submit on the Review step (index 4)
    if (currentStep.value == 4) {
      if (validateAndSubmit()) {
        _submitReport();
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

  /// Navigate to previous step
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
  // 11. UI Helper Methods
  // -------------------------------------------------------------------------

  /// Show error message with consistent styling
  void _showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      backgroundColor: Appcolors.error,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show success message
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Appcolors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  // -------------------------------------------------------------------------
  // 12. Validation Methods
  // -------------------------------------------------------------------------

  /// Validate location information
  bool _validateLocation() {
    if (selectedRegion.value == null) {
      _showError('Please select a Region/City');
      return false;
    }

    final bool isSpecial =
        selectedRegion.value == "Addis Ababa" ||
        selectedRegion.value == "Dire Dawa";
    final String? zoneOrSubCity = isSpecial
        ? selectedSubCity.value
        : selectedZone.value;

    if (zoneOrSubCity == null) {
      _showError('Please select ${isSpecial ? 'a Sub-City' : 'a Zone'}');
      return false;
    }

    if (selectedWoreda.value == null) {
      _showError('Please select a Woreda');
      return false;
    }
    
    if (selectedKebele.value == null) {
      _showError('Please select a Kebele');
      return false;
    }
    
    return true;
  }

  /// Validate timing and incident details
  bool _validateTiming() {
    if (selectedIncidentType.value == null) {
      _showError('Please select Incident Type');
      return false;
    }
    
    if (incidentDate.value == null) {
      _showError('Please select Incident Date');
      return false;
    }
    
    if (incidentTime.value == null) {
      _showError('Please select Incident Time');
      return false;
    }
    
    if (selectedVictim.value == null) {
      _showError('Please select Victim');
      return false;
    }
    
    if (selectedCause.value == null) {
      _showError('Please select Cause');
      return false;
    }
    
    if (selectedLevel.value == null) {
      _showError('Please select Incident Level');
      return false;
    }
    
    if (selectedContext.value == null) {
      _showError('Please select Incident Context');
      return false;
    }

    return true;
  }

  /// Validate details and response information
  bool _validateDetails() {
    if (selectedResponseType.value == null) {
      _showError('Please select Response Type');
      return false;
    }
    
    if (responseDate.value == null) {
      _showError('Please select Response Date');
      return false;
    }
    
    if (responseTime.value == null) {
      _showError('Please select Response Time');
      return false;
    }

    return true;
  }

  /// Validate response details
  bool _validateResponse() {
    if (responseReason.value.trim().isEmpty) {
      _showError('Please enter Reason for Response');
      return false;
    }
    if (actionTaken.value.trim().isEmpty) {
      _showError('Please enter Action Taken');
      return false;
    }
    return true;
  }

  /// Validate current step using centralized validation
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
      case 4: // Review step - always valid
        return true;
      default:
        return true;
    }
  }

  /// Validate all form data before final submission
  bool validateAndSubmit() {
    final locationValid = _validateLocation();
    final timingValid = _validateTiming();
    final detailsValid = _validateDetails();
    final responseValid = _validateResponse();

    if (!locationValid || !timingValid || !detailsValid || !responseValid) {
      _showError('Please fix validation errors before submitting');
      return false;
    }

    return true;
  }

  // -------------------------------------------------------------------------
  // 13. Media Picker
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
        _showError('No file selected');
        return;
      }

      selectedFile.value = file;
      hasAttachment.value = true;

      if (kIsWeb) {
        final bytes = await file.readAsBytes();
        selectedBytes.value = bytes;
      }

      _showSuccess('Attachment added');
    } catch (e) {
      hasAttachment.value = false;
      _showError('Failed to pick image: $e');
    }
  }

  // -------------------------------------------------------------------------
  // 14. Location Management for Flutter Map
  // -------------------------------------------------------------------------
  void updateMarker(LatLng position) {
    if (position != null) {
      isLocationSelelcted(true);
      selectedLocation.value = position;
    } else {
      isLocationSelelcted(false);
      selectedLocation.value = null;
    }
  }

  // -------------------------------------------------------------------------
  // 15. Report Submission
  // -------------------------------------------------------------------------
  void _submitReport() {
    try {
      // Create report model with location data
      final report = ReportModel(
        region: selectedRegion.value ?? '',
        woreda: selectedWoreda.value ?? '',
        kebele: selectedKebele.value ?? '',
        date: incidentDate.value?.toString() ?? '',
        time: incidentTime.value?.format(Get.context!) ?? '',
        description: description.value,
        severity: selectedLevel.value ?? '',
        imagePath: selectedFile.value?.path ?? '',
      );

      // Save to local storage
      _storageService.saveReport(report);

      // Log the report data
      _logReport();

      // Show success dialog
      showThankYouDialog();

      // Reset form after successful submission
      resetForm();

    } catch (e) {
      _showError('Failed to submit report: $e');
    }
  }

  // -------------------------------------------------------------------------
  // 16. Logging & UI helpers
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
    debugPrint("Location: ${selectedLocation.value?.latitude}, ${selectedLocation.value?.longitude}");
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
  // 17. Reset & Edit helpers
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

    // Location fields
    selectedLocation.value = null;
    isLocationSelelcted.value = false;

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
