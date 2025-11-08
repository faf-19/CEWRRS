// lib/presentation/controllers/settings_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  // Mock user data
  final RxString name = 'John Doe'.obs;
  final RxString handle = '@johndoe1'.obs;
  final RxString avatarUrl = ''.obs; // Empty → show placeholder

  // Mock settings items
  final List<SettingsItem> settings = [
    SettingsItem(
      title: 'Account',
      items: [
        SettingsSubItem(icon: Icons.settings, title: 'Account settings', route: '/account-settings'),
        SettingsSubItem(icon: Icons.privacy_tip, title: 'Privacy settings', route: '/privacy-settings'),
      ],
    ),
    SettingsItem(
      title: 'Security',
      items: [
        SettingsSubItem(icon: Icons.security, title: 'Security settings', route: '/security-settings'),
        SettingsSubItem(icon: Icons.notifications, title: 'Notification settings', route: '/notification-settings'),
        SettingsSubItem(icon: Icons.data_usage, title: 'Data usage settings', route: '/data-usage'),
      ],
    ),
    SettingsItem(
      title: 'Theme',
      items: [
        SettingsSubItem(icon: Icons.palette, title: 'Display settings', route: '/display-settings'),
        SettingsSubItem(icon: Icons.language, title: 'Language settings', route: '/language-settings'),
      ],
    ),
  ];

  void editProfilePicture() {
    Get.snackbar(
      'Edit Profile',
      'Pick image from gallery/camera (to be implemented)',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Future: Open image picker
  }

  void navigateTo(String route) {
    Get.toNamed(route);
  }
}

class SettingsItem {
  final String title;
  final List<SettingsSubItem> items;
  SettingsItem({required this.title, required this.items});
}

class SettingsSubItem {
  final IconData icon;
  final String title;
  final String route;
  SettingsSubItem({required this.icon, required this.title, required this.route});
}