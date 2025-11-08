import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';

class ClassicNavBar extends StatelessWidget {
  final HomeController controller;

  const ClassicNavBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: const BoxDecoration(
          color: Appcolors.background,
          boxShadow: [],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          backgroundColor: Colors.transparent,
          selectedItemColor: Appcolors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: _navItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _navItems() => [
    _navItem(Icons.home_outlined, 'Home'),
    _navItem(Icons.report_problem_outlined, 'Report'),
    _navItem(Icons.pin_drop, 'Maps'),
    _navItem(Icons.assessment_rounded, 'status'),
    _navItem(Icons.settings, 'Settings'),
  ];

  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon, size: 35), label: label);
  }
}
