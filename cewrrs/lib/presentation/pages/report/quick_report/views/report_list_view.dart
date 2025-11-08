import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/pages/report/quick_report/views/report_detail_view.dart';
import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:e_carta_app/app/modules/report/views/report_detail_view.dart';
import 'package:e_carta_app/app/modules/report/views/report_view.dart';
import 'package:e_carta_app/config/theme/app_colors.dart';
import 'package:e_carta_app/config/theme/app_text_styles.dart';
import 'package:e_carta_app/data/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '../controllers/report_controller.dart';

class ReportsListView extends StatefulWidget {
  const ReportsListView({super.key});

  @override
  State<ReportsListView> createState() => _ReportsListViewState();
}

class _ReportsListViewState extends State<ReportsListView> {
  final ReportController controller = Get.find<ReportController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        title: Text(
          'Submitted Reports',
          style: AppTextStyles.heading.copyWith(color: Appcolors.background),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Appcolors.background,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Appcolors.background),
            onPressed: () => controller.getReports(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          _buildFilterSection(),

          // Reports List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.reports.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredReports.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: () => controller.getReports(),
                child: VsScrollbar(
                  controller: scrollController,
                  showTrackOnHover: true, // default false
                  isAlwaysShown: true, // default false
                  scrollbarFadeDuration: Duration(
                    milliseconds: 500,
                  ), // default : Duration(milliseconds: 300)
                  scrollbarTimeToFade: Duration(
                    milliseconds: 800,
                  ), // default : Duration(milliseconds: 600)
                  style: VsScrollbarStyle(
                    hoverThickness: 10.0, // default 12.0
                    radius: Radius.circular(10), // default Radius.circular(8.0)
                    thickness: 5.0, // [ default 8.0 ]
                    color: Appcolors.primary.withValues(
                      alpha: 0.05,
                    ), // default ColorScheme Theme
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = controller.filteredReports[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ReportDetailView(report: report));
                        },
                        child: _buildReportCard(report),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 4),
            child: Text(
              "Filter by Status",
              style: AppTextStyles.subheading.copyWith(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          /// Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: controller.filters.map((filter) {
                final isSelected = controller.selectedFilter.value == filter;
                return Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilterChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.applyFilter(selected ? filter : "All");
                    },
                    backgroundColor: _getStatusColor(filter).withOpacity(0.3),
                    selectedColor: _getStatusColor(filter),
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          /// Report Count
          Obx(() {
            final count = controller.filteredReports.length;
            final total = controller.reports.length;
            final filter = controller.selectedFilter.value;

            return Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                filter == "All"
                    ? "Showing $count report${count > 1 ? 's' : ''}"
                    : "Showing $count of $total report${total > 1 ? 's' : ''}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.report_problem_outlined,
            size: 64,
            color: Appcolors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            controller.selectedFilter.value == "All"
                ? 'No reports submitted yet'
                : 'No ${controller.selectedFilter.value.toLowerCase()} reports',
            style: AppTextStyles.subheading.copyWith(color: Appcolors.primary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.getReports(),
            style: ElevatedButton.styleFrom(backgroundColor: Appcolors.primary),
            child: Text(
              'Refresh',
              style: AppTextStyles.button.copyWith(color: Appcolors.background),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    report.reportNo,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    report.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Iconsax.location,
              label: "Location",
              value:
                  '${report.latitude.toStringAsFixed(4)}, ${report.longitude.toStringAsFixed(4)}',
            ),
            _buildInfoRow(
              icon: Iconsax.calendar,
              label: "Submitted At",
              value: _formatDateTime(report.createdAt),
            ),
            const SizedBox(height: 10),
            if (report.description != null && report.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.description!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tap to view details",
                style: TextStyle(
                  fontSize: 9,
                  color: Appcolors.primary.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 6),
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 50),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
      case 'RESOLVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'IN_PROGRESS':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
