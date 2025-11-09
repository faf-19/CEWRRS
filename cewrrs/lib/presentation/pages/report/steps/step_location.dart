import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';

class StepLocation extends StatelessWidget {
  final StaffReportController controller = Get.find();

  StepLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Beautiful Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Appcolors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Appcolors.primary.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Appcolors.primary, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Incident Location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Please provide the exact location where the incident occurred. ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Form Fields
        _dropdown(
          "Region / City",
          controller.regions,
          controller.selectedRegion,
        ),
        const SizedBox(height: 16),

        Obx(() {
          final region = controller.selectedRegion.value;
          final isSpecial = region == "Addis Ababa" || region == "Dire Dawa";
          final label = isSpecial ? "Sub-City" : "Zone";
          final items = isSpecial
              ? controller.subCities[region] ?? []
              : controller.zones;
          final selected = isSpecial
              ? controller.selectedSubCity
              : controller.selectedZone;

          return _dropdown(label, items, selected);
        }),

        const SizedBox(height: 16),
        _dropdown("Woreda", controller.woredas, controller.selectedWoreda),
        const SizedBox(height: 16),
        _dropdown("Kebele", controller.kebeles, controller.selectedKebele),
        const SizedBox(height: 16),

        // Specific Place Name - NO WHITE SPACE BELOW!
        _textField("Specific Place Name", controller.placeName),

        // This removes any extra bottom padding
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _dropdown(String label, List<String> items, RxnString selected) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: selected.value,
        // hint: Text("Select $label"),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Appcolors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Appcolors.primary.withOpacity(0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Appcolors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => selected.value = v,
        dropdownColor: Appcolors.background,
      ),
    );
  }

  Widget _textField(String label, RxString value) {
    return Obx(
      () => TextFormField(
        initialValue: value.value,
        onChanged: (v) => value.value = v,
        decoration: InputDecoration(
          labelText: label,
          // hintText: "e.g. Piassa, near St. George Church",
          filled: true,
          fillColor: Appcolors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Appcolors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
