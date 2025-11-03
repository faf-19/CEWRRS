import 'dart:io';
import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:flutter/foundation.dart';   // <-- for kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickReportPage extends GetView<QuickReportController> {
  const QuickReportPage({super.key});

  // ──────────────────────────────────────────────────────────────
  // Shared decoration – hint disappears when a value is present
  // ──────────────────────────────────────────────────────────────
  static InputDecoration fieldDecoration({
    required String label,
    required bool hasValue,
    bool isRequired = false,
  }) {
    return InputDecoration(
      //labelText: isRequired ? '*' : label,
      labelStyle: TextStyle(
        color: isRequired ? Colors.red.shade700 : null,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      hintText: hasValue ? null : label,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Appcolors.fieldFill,
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Appcolors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Validation – mirrors controller logic (keeps UI in sync)
  // ──────────────────────────────────────────────────────────────
  bool _isFormValid() {
    return controller.selectedRegion.value != null &&
        (controller.selectedZone.value != null ||
            controller.selectedSubCity.value != null) &&
        controller.selectedWoreda.value != null &&
        controller.kebele.value.trim().isNotEmpty &&
        controller.description.value.trim().isNotEmpty &&
        controller.hasAttachment.value;
  }

  // ──────────────────────────────────────────────────────────────
  // Thank‑you dialog + redirect
  // ──────────────────────────────────────────────────────────────
  void _showThankYouAndRedirect(BuildContext context) {
    showDialog(
      context: context,
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
                "Your information has been received safely.\nTogether, we build peace.",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/intro');
    });
  }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Appcolors.textDark),
          onPressed: () => Get.offAllNamed('/intro'),
        ),
        title: Text(
          "Quick Report",
          style: AppTextStyles.heading.copyWith(
            color: Appcolors.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ──────── Region ────────
              const Text("Region/City",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _regionDropdown(),
              const SizedBox(height: 16),
        
              // ──────── Zone / Sub‑City (dynamic) ────────
              Obx(() {
                final region = controller.selectedRegion.value;
                final bool isSpecial =
                    region == "Addis Ababa" || region == "Dire Dawa";
        
                final String label =
                    isSpecial ? "Select Sub‑City" : "Select Zone";
        
                final List<String> items = isSpecial
                    ? controller.subCities[region] ?? []
                    : controller.zones;
        
                final RxnString selected = isSpecial
                    ? controller.selectedSubCity
                    : controller.selectedZone;
        
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    _genericDropdown(label, items, selected,
                        isRequired: true),
                  ],
                );
              }),
              const SizedBox(height: 16),
        
              // ──────── Woreda ────────
              const Text("Woreda",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _genericDropdown(
                  "Select Woreda", controller.woredas, controller.selectedWoreda,
                  isRequired: true),
              const SizedBox(height: 16),
        
              // ──────── Kebele ────────
              const Text("Kebele",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _textField("Enter Kebele", controller.kebele, isRequired: true),
              const SizedBox(height: 16),
        
              // ──────── Attachment ────────
              const Text("Attachment",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _uploadField(),
              const SizedBox(height: 16),
        
              // ──────── Description (required) ────────
              const Text("Description",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _textField("Enter a description", controller.description,
                  maxLines: 5, isRequired: true),
              const SizedBox(height: 32),
        
              // ──────── Submit ────────
              Obx(() {
                final canSubmit = _isFormValid();
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canSubmit
                        ? () async {
                            final success = controller.validateAndSubmit();
                            if (success) {
                              _showThankYouAndRedirect(context);
                              controller.resetForm(); // clear form for next report
                            }
                          }
                        : () {
                            Get.snackbar(
                              'Incomplete',
                              'Please fill all required fields and attach a file.',
                              backgroundColor: Colors.red.shade600,
                              colorText: Colors.white,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          canSubmit ? Appcolors.primary : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                    ),
                    child: Text(
                      canSubmit ? "Submit Report" : "Complete Required Fields",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Region dropdown
  // ──────────────────────────────────────────────────────────────
  Widget _regionDropdown() {
    return Obx(() {
      final hasValue = controller.selectedRegion.value != null;
      return DropdownButtonFormField<String>(
        value: controller.selectedRegion.value,
        decoration: fieldDecoration(
            label: "Select Region/City",
            hasValue: hasValue,
            isRequired: true),
        icon: const Icon(Icons.keyboard_arrow_down, color: Appcolors.primary),
        dropdownColor: Colors.white,
        isExpanded: true,
        alignment: Alignment.centerLeft,
        menuMaxHeight: 300,
        itemHeight: 48,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        items: controller.regions
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: (v) {
          controller.selectedRegion.value = v;
          controller.selectedZone.value = null;
          controller.selectedSubCity.value = null;
        },
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Generic dropdown (Zone/Sub‑City, Woreda)
  // ──────────────────────────────────────────────────────────────
  Widget _genericDropdown(
      String label, List<String> items, RxnString selected,
      {bool isRequired = false}) {
    return Obx(() {
      final hasValue = selected.value != null;
      return DropdownButtonFormField<String>(
        value: selected.value,
        decoration: fieldDecoration(
            label: label, hasValue: hasValue, isRequired: isRequired),
        icon: const Icon(Icons.keyboard_arrow_down, color: Appcolors.primary),
        dropdownColor: Colors.white,
        isExpanded: true,
        alignment: Alignment.centerLeft,
        menuMaxHeight: 300,
        itemHeight: 48,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Text field (Kebele / Description)
  // ──────────────────────────────────────────────────────────────
  Widget _textField(String label, RxString value,
      {int maxLines = 1, bool isRequired = false}) {
    return Obx(() {
      final hasValue = value.value.isNotEmpty;
      return TextFormField(
        initialValue: value.value,
        maxLines: maxLines,
        onChanged: (v) => value.value = v,
        decoration: fieldDecoration(
            label: label, hasValue: hasValue, isRequired: isRequired),
        style: const TextStyle(fontSize: 14),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────
  // Upload field – preview works on mobile AND web
  // ──────────────────────────────────────────────────────────────
  Widget _uploadField() {
    return Obx(() {
      final file = controller.selectedFile.value;
      final hasFile = controller.hasAttachment.value;

      return GestureDetector(
        onTap: controller.pickMedia,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Appcolors.fieldFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: hasFile ? Appcolors.primary : Colors.grey.shade300,
                width: hasFile ? 2 : 1),
          ),
          child: Column(
            children: [
              // ─── Image preview (mobile) ───
              if (file != null && !kIsWeb) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(file.path),
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ]
              // ─── Image preview (web) ───
              else if (file != null && kIsWeb && controller.selectedBytes.value != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    controller.selectedBytes.value!,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              Icon(
                hasFile ? Icons.check_circle : Icons.cloud_upload_outlined,
                size: 32,
                color: Appcolors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                hasFile
                    ? "Tap to change attachment *"
                    : "Click to Snap or Upload a Picture/Video *",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: hasFile ? Appcolors.primary : Appcolors.textDark,
                    fontWeight: hasFile ? FontWeight.w600 : null),
              ),
            ],
          ),
        ),
      );
    });
  }
}