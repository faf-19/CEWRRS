import 'package:cewrrs/presentation/controllers/quick_report_controller.dart';
import 'package:get/get.dart';

/// Binding for Quick Report functionality
/// This fixes the naming inconsistency and typo in the original file
class QuickReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuuickReportController>(
      () => QuuickReportController(),
    );
  }
}
