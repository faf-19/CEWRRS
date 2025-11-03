import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Report {
  final String id;
  final String title;
  final String status;
  final String assignedTo;
  final String date;
  final String location;
  final String priority;
  final String category;
  final String resolution;
  final String notes;

  Report({
    required this.id,
    required this.title,
    required this.status,
    required this.assignedTo,
    required this.date,
    required this.location,
    required this.priority,
    required this.category,
    required this.resolution,
    required this.notes,
  });
}

class StatusController extends GetxController {
  var reports = <Report>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    reports.value = [
      Report(
        id: 'R001',
        title: 'Water Leakage',
        status: 'Pending',
        assignedTo: 'Staff A',
        date: '2025-10-30',
        location: 'Zone 3',
        priority: 'High',
        category: 'Plumbing',
        resolution: 'Not yet resolved',
        notes: 'Reported by resident near pipeline.',
      ),
      Report(
        id: 'R002',
        title: 'Power Outage',
        status: 'Resolved',
        assignedTo: 'Staff B',
        date: '2025-10-29',
        location: 'Zone 1',
        priority: 'Medium',
        category: 'Electrical',
        resolution: 'Transformer replaced',
        notes: 'Issue resolved within 2 hours.',
      ),
    ];
  }

  void showDetails(Report report) {
    Get.defaultDialog(
      title: 'Full Report Details',
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${report.id}'),
            Text('Title: ${report.title}'),
            Text('Status: ${report.status}'),
            Text('Assigned To: ${report.assignedTo}'),
            Text('Date: ${report.date}'),
            Text('Location: ${report.location}'),
            Text('Priority: ${report.priority}'),
            Text('Category: ${report.category}'),
            Text('Resolution: ${report.resolution}'),
            Text('Notes: ${report.notes}'),
          ],
        ),
      ),
    );
  }
}

