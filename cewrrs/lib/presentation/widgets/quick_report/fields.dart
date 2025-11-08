import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration quickReportFieldDecoration({
  required String label,
  required bool hasValue,
  bool isRequired = false,
}) {
  return InputDecoration(
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

class RegionDropdown extends StatelessWidget {
  const RegionDropdown({super.key, required this.controller});

  final QuickReportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasValue = controller.selectedRegion.value != null;
      return DropdownButtonFormField<String>(
        value: controller.selectedRegion.value,
        decoration: quickReportFieldDecoration(
          label: "Select Region/City",
          hasValue: hasValue,
          isRequired: true,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Appcolors.primary),
        dropdownColor: Colors.white,
        isExpanded: true,
        alignment: Alignment.centerLeft,
        menuMaxHeight: 300,
        itemHeight: 48,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        items: controller.regions
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (v) {
          controller.selectedRegion.value = v;
          controller.selectedZone.value = null;
          controller.selectedSubCity.value = null;
        },
      );
    });
  }
}

class GenericDropdown extends StatelessWidget {
  const GenericDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selected,
    this.isRequired = false,
  });

  final String label;
  final List<String> items;
  final RxnString selected;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasValue = selected.value != null;
      return DropdownButtonFormField<String>(
        value: selected.value,
        decoration: quickReportFieldDecoration(
          label: label,
          hasValue: hasValue,
          isRequired: isRequired,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Appcolors.primary),
        dropdownColor: Colors.white,
        isExpanded: true,
        alignment: Alignment.centerLeft,
        menuMaxHeight: 300,
        itemHeight: 48,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }
}

class ReactiveTextField extends StatelessWidget {
  const ReactiveTextField({
    super.key,
    required this.label,
    required this.value,
    this.maxLines = 1,
    this.isRequired = false,
  });

  final String label;
  final RxString value;
  final int maxLines;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasValue = value.value.isNotEmpty;
      return TextFormField(
        initialValue: value.value,
        maxLines: maxLines,
        onChanged: (v) => value.value = v,
        decoration: quickReportFieldDecoration(
          label: label,
          hasValue: hasValue,
          isRequired: isRequired,
        ),
        style: const TextStyle(fontSize: 14),
      );
    });
  }
}
