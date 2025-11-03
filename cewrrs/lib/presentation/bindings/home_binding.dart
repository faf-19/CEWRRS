import 'package:cewrrs/presentation/controllers/status_controller.dart';
import 'package:get/get.dart';
import 'package:cewrrs/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
