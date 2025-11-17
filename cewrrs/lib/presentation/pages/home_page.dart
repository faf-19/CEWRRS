// lib/presentation/pages/home/home_page.dart
import 'package:cewrrs/presentation/pages/report/quick_report/views/report_view.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/widgets/donut_chart_painter.dart';
import 'package:cewrrs/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/widgets/classic_navbar.dart';
import 'package:cewrrs/presentation/widgets/Custom_AppBar.dart';
import 'package:cewrrs/presentation/pages/report/staff_report_page.dart';
import 'package:cewrrs/presentation/pages/map/maps_page.dart';
import 'package:cewrrs/presentation/pages/status_page.dart';
import 'package:cewrrs/presentation/pages/Settings_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  UserType? getCurrentUserType() {
    final storage = GetStorage();
    final userTypeString = storage.read('user_type');
    if (userTypeString != null) {
      return UserType.values.firstWhere(
        (e) => e.toString().split('.').last == userTypeString,
        orElse: () => UserType.public,
      );
    }
    return UserType.public; // default to public
  }

  bool get isUserLoggedIn {
    final storage = GetStorage();
    return storage.read('is_logged_in') == true;
  }

  List<Widget> get _pages {
    final userType = getCurrentUserType() ?? UserType.public;

    if (userType == UserType.staff) {
      // Staff users: 0 home, 1 staff_report, 2 map, 3 settings
      return [
        const _HomeDashboard(),
        StaffReportPage(),
        MapsPage(),
        SettingsView(),
      ];
    } else {
      // Public users: 0 home, 1 report, 2 status, 3 settings
      return [
        const _HomeDashboard(),
        ReportView(isSign: false),
        StatusPage(),
        SettingsView(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(controller: controller),
      bottomNavigationBar: ClassicNavBar(controller: controller),
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HomeDashboard – Blank View
// ─────────────────────────────────────────────────────────────────────────────
class _HomeDashboard extends GetView<HomeController> {
  const _HomeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.background,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your home dashboard',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
