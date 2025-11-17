import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';

class StepDetails extends StatelessWidget {
  final StaffReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  Icon(Icons.access_alarm, color: Appcolors.primary, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Response Timing",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.primary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Please provide the exact location where the incident occurred. ",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.5,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        _dropdown(
          "Response Type",
          controller.responseTypes,
          controller.selectedResponseType,
        ),
        const SizedBox(height: 16),
        _datePicker("Response Date", controller.responseDate),
        const SizedBox(height: 16),
        _timePicker("Response Time", controller.responseTime),
        const SizedBox(height: 16),
      ],
    );
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
            fillColor: Appcolors.fieldFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selected.value != null
                ? "${selected.value!.toLocal()}".split(' ')[0]
                : "Select Date",
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12),
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
            fillColor: Appcolors.fieldFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            selected.value != null
                ? selected.value!.format(Get.context!)
                : "Select Time",
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12),
          ),
        ),
      );
    });
  }

  Widget _dropdown(String label, List<String> items, RxnString selected) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: selected.value,
        hint: Text("Select $label", style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: Appcolors.primary)),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Appcolors.fieldFill,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12))))
            .toList(),
        onChanged: (v) => selected.value = v,
      );
    });
  }
}
