import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import '../../../themes/colors.dart';

class StepLocation extends StatelessWidget {
  final ReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown("Region/City", controller.regions, controller.selectedRegion),
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
        _dropdown("Kebele", controller.Kebeles, controller.selectedKebele),
        const SizedBox(height: 16),
        _textField("place Name", controller.placeName )
        
      ],
    );
  }

  Widget _dropdown(String label, List<String> items, RxnString selected) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: selected.value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Appcolors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }

  Widget _textField(String label, RxString value) {
    return Obx(() {
      return TextFormField(
        initialValue: value.value,
        onChanged: (v) => value.value = v,
        decoration: InputDecoration(
          labelText: label,
          
          filled: true,
          fillColor: Appcolors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Appcolors.primary, width: 0.5)),
        ),
      );
    });
  }
}
