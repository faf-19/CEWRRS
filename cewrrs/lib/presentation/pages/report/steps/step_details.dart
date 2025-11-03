import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import '../../../themes/colors.dart';

class StepDetails extends StatelessWidget {
  final ReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown("Victim of the Incident", controller.victims, controller.selectedVictim),
        const SizedBox(height: 16),
        _dropdown("Cause of the Incident", controller.causes, controller.selectedCause),
        const SizedBox(height: 16),
        _dropdown("Incident Level", controller.levels, controller.selectedLevel),
        const SizedBox(height: 16),
        _dropdown("Incident Context", controller.contexts, controller.selectedContext),
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
          fillColor: Appcolors.fieldFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }
}
