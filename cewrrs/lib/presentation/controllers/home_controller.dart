import 'package:cewrrs/presentation/pages/SOS_page.dart';
import 'package:cewrrs/presentation/pages/home_page.dart';
import 'package:cewrrs/presentation/pages/report/quick_report_page.dart';
import 'package:cewrrs/presentation/pages/report/report_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  final userEmail = ''.obs;
  final selectedIndex = 0.obs;
  final tabHistory = <int>[0].obs;

  // Pages for IndexedStack
  final pages = [
    const HomePage(),
    ReportPage(),
    MapsPage(),
    StatusPage(),
    SosPage(),
    QuickReportPage(),
  ];

  @override
  void onInit() {
    super.onInit();
    final user = storage.read('user');
    userEmail.value = user?['email'] ?? 'Guest';
  }

  void changeTab(int index) {
    if (selectedIndex.value != index) {
      tabHistory.add(index);
      selectedIndex.value = index;
    }
  }

  void goBackInTabFlow() {
    if (tabHistory.length > 1) {
      tabHistory.removeLast();
      selectedIndex.value = tabHistory.last;
    }
  }

  void logout() {
    storage.remove('user');
    Get.offAllNamed('/login');
  }
}
