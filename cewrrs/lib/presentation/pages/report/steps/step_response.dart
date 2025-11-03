import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import '../../../themes/colors.dart';

class StepResponse extends StatelessWidget {
  final ReportController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // 🐛 FIX: Wrap the Column in SingleChildScrollView to prevent overflow.
    return SingleChildScrollView(
      padding: EdgeInsets.zero, // Padding is handled by the parent ReportPage container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dropdown("Response Type", controller.responseTypes, controller.selectedResponseType),
          const SizedBox(height: 16),
          _datePicker("Response Date", controller.responseDate),
          const SizedBox(height: 16),
          _timePicker("Response Time", controller.responseTime),
          const SizedBox(height: 16),
          _uploadField(),
          const SizedBox(height: 16),
          // Incident description is required on final submit
          _textField("Incident Description", controller.description, maxLines: 4),
          const SizedBox(height: 16),
          _textField("Reason for Response", controller.responseReason),
          const SizedBox(height: 16),
          _textField("Action Taken (Details)", controller.actionTaken, maxLines: 4),
          
          // Added space at the bottom to ensure the last text field is above the navigation buttons.
          const SizedBox(height: 80), 
        ],
      ),
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
            fillColor: Appcolors.fieldFill,
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

Widget _textField(String label, RxString value, {int maxLines = 1}) {
  return Obx(() {
    return TextFormField(
      initialValue: value.value,
      onChanged: (v) => value.value = v,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Appcolors.fieldFill,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  });
}


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
              width: hasFile ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
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
              ] else if (file != null && kIsWeb && controller.selectedBytes.value != null) ...[
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
                    ? "Tap to change attachment"
                    : "Click to Snap or Upload a Picture/Video",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: hasFile ? Appcolors.primary : Appcolors.textDark,
                  fontWeight: hasFile ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}