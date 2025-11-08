// lib/presentation/pages/settings/settings_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/settings_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Wave Header
            _buildWaveHeader(),
            const SizedBox(height: 20),

            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 30),

            // Settings List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.settings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final section = controller.settings[index];
                  return _buildSection(section);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveHeader() {
    return Container(
      height: 20,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Appcolors.background,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: ClipPath(
        clipper: WaveClipper(),
        child: Container(color: Appcolors.primary),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(
                () => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: controller.avatarUrl.value.isNotEmpty
                      ? NetworkImage(controller.avatarUrl.value)
                      : null,
                  child: controller.avatarUrl.value.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.editProfilePicture,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Appcolors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
          () => Text(
            controller.name.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Text(
            controller.handle.value,
            style: TextStyle(fontSize: 14, color: Colors.blue[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(SettingsItem section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: section.items
                .map(
                  (item) => ListTile(
                    leading: Icon(item.icon, color: Colors.black54),
                    title: Text(item.title),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () => controller.navigateTo(item.route),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

// Wave Clipper for header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 40,
    );
    path.quadraticBezierTo(
      3 / 4 * size.width,
      size.height - 80,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
