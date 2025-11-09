import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;

  const CustomAppbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final titles = [
      "Dashboard",
      "Report",
      "Maps",
      "status",
      "Settings",
      "OTP Verification",
      "ReportView",
    ];

    return Obx(
      () => AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: controller.tabHistory.length <= 1
            ? null
            : IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Appcolors.textDark,
                ),
                onPressed: controller.goBackInTabFlow,
              ),

        title: Text(
          titles[controller.selectedIndex.value],
          style: AppTextStyles.heading.copyWith(
            color: Appcolors.textDark,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset('assets/images/logo.png', width: 32, height: 32),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
