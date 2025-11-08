import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:cewrrs/presentation/themes/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ReportDetailView extends StatelessWidget {
  final Report report;

  const ReportDetailView({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primary,
        title: Text(
          'Report Details',
          style: AppTextStyles.heading.copyWith(color: Appcolors.background),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Appcolors.background,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Header Card
            _buildHeaderCard(),
            const SizedBox(height: 16),

            // Description Section
            _buildDescriptionSection(),
            const SizedBox(height: 16),

            // Location Details
            // _buildLocationSection(),
            const SizedBox(height: 16),

            // // Timeline Section
            // _buildTimelineSection(),
            // const SizedBox(height: 16),

            // // Contact Information
            // _buildContactSection(),
            // const SizedBox(height: 16),

            // // Assigned Police Station (if available)
            // _buildPoliceStationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Ticket Number ${report.reportNo}",
                    style: TextStyle(
                      fontFamily: "",
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Appcolors.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(report.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    report.status,
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            // Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeaderItem(
                  icon: Iconsax.calendar,
                  label: '',
                  value: _formatDateTime(report.incidentTime),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Appcolors.primary),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Appcolors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.note_text, size: 18, color: Appcolors.primary),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.description ?? 'No description provided',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.location, size: 18, color: Appcolors.primary),
                const SizedBox(width: 8),
                Text(
                  'Location Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              label: 'Coordinates',
              value:
                  '${report.latitude.toStringAsFixed(6)}, ${report.longitude.toStringAsFixed(6)}',
            ),
            if (report.uniqueLocationName != null)
              _buildDetailRow(
                label: 'Location Name',
                value: report.uniqueLocationName!,
              ),
            if (report.woredaId != null)
              _buildDetailRow(label: 'Woreda ID', value: report.woredaId!),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.clock, size: 18, color: Appcolors.primary),
                const SizedBox(width: 8),
                Text(
                  'Timeline',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTimelineItem(
              icon: Iconsax.calendar_1,
              title: 'Incident Occurred',
              time: _formatDateTime(report.incidentTime),
            ),
            _buildTimelineItem(
              icon: Iconsax.add_circle,
              title: 'Report Submitted',
              time: _formatDateTime(report.createdAt),
            ),
            _buildTimelineItem(
              icon: Iconsax.refresh,
              title: 'Last Updated',
              time: _formatDateTime(report.updatedAt),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String time,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, size: 16, color: Appcolors.primary),
              if (!isLast)
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.only(top: 4),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.user, size: 18, color: Appcolors.primary),
                const SizedBox(width: 8),
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (report.phoneNumber != null)
              _buildDetailRow(
                label: 'Phone Number',
                value: report.phoneNumber!,
              ),
            if (report.senderId != null)
              _buildDetailRow(label: 'Sender ID', value: report.senderId!),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliceStationSection() {
    // This would come from your API response
    final assignedStation = "Addis Ababa Police Station"; // Example data
    final stationPhone = "+251 11 123 4567"; // Example data

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.building_3, size: 18, color: Appcolors.primary),
                const SizedBox(width: 8),
                Text(
                  'Assigned Police Station',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Appcolors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(label: 'Station Name', value: assignedStation),
            _buildDetailRow(label: 'Phone Number', value: stationPhone),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
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
      case 'APPROVED':
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

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
