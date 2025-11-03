import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import '../../../themes/colors.dart';

class StepTiming extends StatelessWidget {
  final ReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dropdown("Incident Type", controller.incidentTypes, controller.selectedIncidentType),
        const SizedBox(height: 16),
        _datePicker("Incident Date", controller.incidentDate),
        const SizedBox(height: 16),
        _timePicker("Incident Time", controller.incidentTime),
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
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }

  Widget _datePicker(String label, Rxn<DateTime> selected) {
    return Obx(() {
      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) selected.value = picked;
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Appcolors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selected.value != null
                ? "${selected.value!.toLocal()}".split(' ')[0]
                : "Select Date",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    });
  }

  Widget _timePicker(String label, Rxn<TimeOfDay> selected) {
    return Obx(() {
      return InkWell(
        onTap: () async {
          final picked = await showTimePicker(
            context: Get.context!,
            initialTime: TimeOfDay.now(),
          );
          if (picked != null) selected.value = picked;
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Appcolors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selected.value != null
                ? selected.value!.format(Get.context!)
                : "Select Time",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    });
  }
}
