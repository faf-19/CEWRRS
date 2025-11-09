import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:get/get.dart';

import '../controllers/staff_report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuuickReportController>(
      () => QuuickReportController(),
    );
  }
}
