import 'package:flutter/material.dart';

class ReportModel {
  final String region;
  final String woreda;
  final String kebele;
  final String date;
  final String time;
  final String description;
  final String severity;
  final String imagePath;

  ReportModel({
    required this.region,
    required this.woreda,
    required this.kebele,
    required this.date,
    required this.time,
    required this.description,
    required this.severity,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'region': region,
        'woreda': woreda,
        'kebele': kebele,
        'date': date,
        'time': time,
        'description': description,
        'severity': severity,
        'imagePath': imagePath,
      };

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        region: json['region'] ?? '',
        woreda: json['woreda'] ?? '',
        kebele: json['kebele'] ?? '',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        description: json['description'] ?? '',
        severity: json['severity'] ?? '',
        imagePath: json['imagePath'] ?? '',
      );
}
