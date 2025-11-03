import 'package:get/get.dart';
import '../controllers/quick_report_controller.dart';

class QuickReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuickReportController());
  }
}
