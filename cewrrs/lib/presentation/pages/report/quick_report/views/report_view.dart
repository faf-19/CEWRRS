import 'package:cewrrs/presentation/controllers/quick_report_controller.dart'
    show QuuickReportController;
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/mapview.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendaudio.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendfile.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendphoto.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/widgets/sendvideo.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportView extends StatefulWidget {
  final int initialTabIndex;
  final bool isSign;
  const ReportView({super.key, this.initialTabIndex = 0, required this.isSign});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final QuuickReportController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(QuuickReportController());
    controller.tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Appcolors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // ────── Scrollable Content ──────
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // space for FAB
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Text(
                    'Quick Report'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Appcolors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Tab Bar (Only when showAll) ──
                  Obx(() => controller.showAll.value
                      ? _buildTabBar()
                      : const SizedBox.shrink()),
                  const SizedBox(height: 12),

                  // ── Tab Content (Fixed Height) ──
                  _buildTabBarView(),

                  const SizedBox(height: 16),

                  // ── Add Photos Card ──
                  SendPhotoWidget(reportController: controller),

                  const SizedBox(height: 16),

                  // ── Description Card ──
                  _buildDescriptionCard(),

                  const SizedBox(height: 16),

                  // ── When & Where Card ──
                  _buildTimePlaceCard(),
                ],
              ),
            ),

            // ────── FAB Submit Button ──────
            Positioned(
              bottom: 20,
              left: size.width * 0.15,
              right: size.width * 0.15,
              child: _buildSubmitButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────── UI Widgets ──────────────────────

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Appcolors.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: controller.tabController,
        indicator: const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        onTap: (i) {
          controller.changeTabIndex(i);
          controller.tabController.animateTo(i);
        },
        tabs: List.generate(4, (i) {
          final icons = [
            Iconsax.camera,
            Iconsax.video,
            Iconsax.voice_cricle,
            Iconsax.document,
          ];
          final isActive = controller.tabIndex == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isActive ? Appcolors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icons[i],
              color: isActive ? Colors.white : Appcolors.primary,
              size: 26,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 140,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: [
          SendPhotoWidget(reportController: controller),
          SendVideoWidget(reportController: controller, isSignLangauge: widget.isSign),
          SendaudioWidget(reportController: controller),
          SendFileWidget(reportController: controller),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.edit_2, color: Appcolors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Describe what happened'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Form(
              key: controller.descriptionformKey,
              child: TextFormField(
                controller: controller.description,
                maxLines: 4,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type here...'.tr,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  suffixIcon: Obx(() => Padding(
                        padding: const EdgeInsets.only(right: 12, top: 8),
                        child: Chip(
                          backgroundColor: Appcolors.primary.withOpacity(.1),
                          label: Text(
                            '${controller.wordCount.value}/20',
                            style: const TextStyle(fontSize: 11, color: Appcolors.primary),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePlaceCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.calendar_1, color: Appcolors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'When & Where'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTimeTile()),
                const SizedBox(width: 12),
                Expanded(child: _buildPlaceTile()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTile() {
    return Obx(() => _pickerTile(
          icon: Iconsax.clock,
          label: controller.isDateSelelcted.value ? 'Time selected' : 'Time',
          onTap: _selectTime,
          isSelected: controller.isDateSelelcted.value,
        ));
  }

  Widget _buildPlaceTile() {
    return Obx(() => _pickerTile(
          icon: Iconsax.location,
          label: controller.isLocationSelelcted.value ? 'Place selected' : 'Place',
          onTap: () => Get.to(() => MapView()),
          isSelected: controller.isLocationSelelcted.value,
        ));
  }

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Appcolors.primary.withOpacity(.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Appcolors.primary.withOpacity(.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Appcolors.primary, size: 20),
            const SizedBox(width: 10),
            Text(
              label.tr,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Appcolors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    // controller.submitReport();
                    Get.toNamed("/phone");
                  },
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Iconsax.send_2, size: 22),
            label: Text(
              'Submit Report'.tr,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
          ),
        ));
  }

  void _selectTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (_, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Appcolors.primary,
          colorScheme: const ColorScheme.light(primary: Appcolors.primary),
        ),
        child: child!,
      ),
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (_, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Appcolors.primary,
          colorScheme: const ColorScheme.light(primary: Appcolors.primary),
        ),
        child: child!,
      ),
    );

    if (time != null) {
      final full = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      controller.selectedDateTime.value = full;
      controller.isDateSelelcted(true);
    } else {
      controller.isDateSelelcted(false);
    }
  }
}