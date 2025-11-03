import 'package:get/get.dart';

class LanguageController extends GetxController {
  final selectedLanguage = 'English'.obs;

  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
    // Optional: Add localization logic here
  }
}
