import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/language_controller.dart';

class LanguageSelector extends StatelessWidget {
  final LanguageController langController;

  const LanguageSelector({super.key, required this.langController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text("Select Language", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTile("English"),
                _buildTile("Amharic"),
                _buildTile("Oromo"),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language, color: Colors.white70, size: 22),
          const SizedBox(width: 8),
          Text(langController.selectedLanguage.value, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      )),
    );
  }

  Widget _buildTile(String name) {
    return ListTile(
      title: Text(name),
      trailing: Obx(() => Radio<String>(
        value: name,
        groupValue: langController.selectedLanguage.value,
        onChanged: (value) {
          if (value != null) {
            langController.selectedLanguage.value = value;
            Get.back();
          }
        },
      )),
      onTap: () {
        langController.selectedLanguage.value = name;
        Get.back();
      },
    );
  }
}
