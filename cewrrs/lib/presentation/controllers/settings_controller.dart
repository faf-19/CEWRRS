// lib/presentation/controllers/settings_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/user_model.dart';

class SettingsController extends GetxController {
  final storage = GetStorage();
  
  // User profile data
  final RxString name = 'John Doe'.obs;
  final RxString handle = '@johndoe1'.obs;
  final RxString avatarUrl = ''.obs; // Empty → show placeholder
  final RxString phoneNumber = ''.obs;
  final RxString email = ''.obs;

  // Current user type
  UserType? get currentUserType {
    final userTypeString = storage.read('user_type');
    if (userTypeString != null) {
      return UserType.values.firstWhere(
        (e) => e.toString().split('.').last == userTypeString,
        orElse: () => UserType.public,
      );
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final currentUser = storage.read('current_user');
    if (currentUser != null) {
      phoneNumber.value = currentUser;
      handle.value = '@user${currentUser.substring(currentUser.length - 4)}';
    }
  }

  // Settings sections
  final List<SettingsItem> settings = [
    SettingsItem(
      title: 'Application',
      items: [
        SettingsSubItem(icon: Icons.language, title: 'Language Preference', route: '/language-settings'),
        SettingsSubItem(icon: Icons.contacts, title: 'Contact Us', route: '/contact-us'),
        SettingsSubItem(icon: Icons.description, title: 'Terms and Conditions', route: '/terms-conditions'),
      ],
    ),
    SettingsItem(
      title: 'Account',
      items: [
        SettingsSubItem(icon: Icons.account_circle, title: 'Profile Settings', route: '/profile-settings'),
        SettingsSubItem(icon: Icons.security, title: 'Security Settings', route: '/security-settings'),
        SettingsSubItem(icon: Icons.notifications, title: 'Notification Settings', route: '/notification-settings'),
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
    if (route == '/language-settings') {
      _showLanguageDialog();
    } else if (route == '/contact-us') {
      _showContactDialog();
    } else if (route == '/terms-conditions') {
      _showTermsDialog();
    } else if (route == '/logout') {
      _showLogoutDialog();
    } else {
      Get.toNamed(route);
    }
  }

  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              trailing: Radio<String>(
                value: 'en',
                groupValue: 'en', // Current selection
                onChanged: (value) {
                  Get.back();
                  Get.snackbar('Language', 'English selected', snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Amharic'),
              trailing: Radio<String>(
                value: 'am',
                groupValue: 'en', // Current selection
                onChanged: (value) {
                  Get.back();
                  Get.snackbar('Language', 'Amharic selected', snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Contact Us'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 12),
                Text('+251-911-123-456'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 12),
                Text('support@cewrrs.com'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 12),
                Text('Addis Ababa, Ethiopia'),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 12),
                Text('24/7 Support Available'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'By using CEWRRS, you agree to the following terms:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '1. User Responsibility: Users are responsible for the accuracy of reported information.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '2. Emergency Use: This app is intended for genuine emergency reporting only.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '3. Data Privacy: We respect your privacy and protect your personal information.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '4. Service Availability: We strive for 24/7 service but cannot guarantee uninterrupted access.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '5. Legal Compliance: Users must comply with local laws and regulations.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Clear user session
    storage.remove('current_user');
    storage.write('is_logged_in', false);
    storage.remove('user_type');
    
    Get.snackbar('Logout', 'You have been logged out successfully', snackPosition: SnackPosition.BOTTOM);
    
    // Navigate to intro/login
    Get.offAllNamed('/intro');
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