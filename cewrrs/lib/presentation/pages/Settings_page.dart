// lib/presentation/pages/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cewrrs/data/models/user_model.dart';
import 'package:cewrrs/presentation/controllers/settings_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final userType = _getCurrentUserType() ?? UserType.public;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              _buildProfileSection(userType),
              const SizedBox(height: 32),

              // Settings Sections
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserType userType) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: userType == UserType.staff
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [Appcolors.primary, Appcolors.primary.withOpacity(0.8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (userType == UserType.staff ? Colors.red : Appcolors.primary).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                userType == UserType.staff
                    ? Icons.admin_panel_settings_rounded
                    : Icons.person_rounded,
                size: 40,
                color: userType == UserType.staff ? Colors.red.shade600 : Appcolors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Name
          Obx(
            () => Text(
              Get.find<SettingsController>().name.value.isNotEmpty
                  ? Get.find<SettingsController>().name.value
                  : 'User',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
                fontFamily: 'Montserrat',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Phone Number
          Obx(
            () => Text(
              Get.find<SettingsController>().phoneNumber.value.isNotEmpty
                  ? Get.find<SettingsController>().phoneNumber.value
                  : 'Phone not set',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // User Type Badge
          if (userType == UserType.staff)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                'STAFF ACCOUNT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language Preference
        _buildSettingsItem(
          icon: Icons.language_rounded,
          title: 'Language Preference',
          onTap: () => Get.find<SettingsController>().navigateTo('/language'),
        ),
        const SizedBox(height: 16),

        // Terms and Conditions
        _buildSettingsItem(
          icon: Icons.description_rounded,
          title: 'Terms and Conditions',
          onTap: () => Get.find<SettingsController>().navigateTo('/terms'),
        ),
        const SizedBox(height: 16),

        // Contact Us
        _buildSettingsItem(
          icon: Icons.contact_support_rounded,
          title: 'Contact Us',
          onTap: () => Get.find<SettingsController>().navigateTo('/contact'),
        ),
        const SizedBox(height: 32),

        // Logout Button
        Center(
          child: Container(
            width: 200, // Adjustable width instead of full width
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade200.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => Get.find<SettingsController>().navigateTo('/logout'),
              icon: const Icon(Icons.logout_rounded, size: 24),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Appcolors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Appcolors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

