import 'package:cewrrs/presentation/controllers/ThemeController.dart';
import 'package:cewrrs/presentation/controllers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/core/config/app_theme.dart';
import 'package:cewrrs/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  Get.put(ThemeController()); // Inject controller
  Get.put(LanguageController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/intro',
      getPages: AppPages.routes,
    ));
  }
}
