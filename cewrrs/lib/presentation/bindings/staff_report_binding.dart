import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:cewrrs/presentation/controllers/staff_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class StaffReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffReportController>(() => StaffReportController());
  }
}
