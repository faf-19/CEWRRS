// lib/presentation/bindings/settings_binding.dart
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
        print('SettingsBinding executed');
    Get.put(SettingsController());

  }
}