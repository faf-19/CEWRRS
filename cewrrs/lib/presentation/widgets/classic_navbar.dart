import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import '../../data/models/user_model.dart';

class ClassicNavBar extends StatelessWidget {
  final HomeController controller;

  const ClassicNavBar({super.key, required this.controller});

  UserType? _getCurrentUserType() {
    final storage = GetStorage();
    final userTypeString = storage.read('user_type');
    if (userTypeString != null) {
      return UserType.values.firstWhere(
        (e) => e.toString().split('.').last == userTypeString,
        orElse: () => UserType.public,
      );
    }
    return UserType.public;
  }

  bool _isUserLoggedIn() {
    final storage = GetStorage();
    return storage.read('is_logged_in') == true;
  }

  @override
  Widget build(BuildContext context) {
    final userType = _getCurrentUserType() ?? UserType.public;
    final isLoggedIn = _isUserLoggedIn();
    
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Appcolors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          backgroundColor: Appcolors.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.7),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            fontFamily: 'Montserrat',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            fontFamily: 'Montserrat',
          ),
          items: _navItems(userType, isLoggedIn),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _navItems(UserType userType, bool isLoggedIn) {
    if (userType == UserType.staff) {
      // Staff navigation: 0 home, 1 staff_report, 2 map, 3 settings
      return [
        _navItem(Icons.dashboard_rounded, 'Home'),
        _navItem(Icons.admin_panel_settings_outlined, 'Staff Report', isStaff: true),
        _navItem(Icons.pin_drop, 'Maps'),
        _navItem(Icons.settings, 'Settings'),
      ];
    } else {
      // Public user navigation: 0 home, 1 report, 2 status, 3 settings
      return [
        _navItem(Icons.dashboard_rounded, 'Home'),
        _navItem(Icons.report_problem_outlined, 'Report'),
        _navItem(Icons.assessment_rounded, 'Status'),
        _navItem(Icons.settings, 'Settings'),
      ];
    }
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, {bool isStaff = false}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 35),
      label: label,
    );
  }
}
