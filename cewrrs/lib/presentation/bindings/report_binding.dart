import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/controllers/report_controller.dart';
class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
