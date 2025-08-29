import 'package:get/get.dart';
import 'package:school_admin_app/pages/homework/controllers/homework_controller.dart';

class HomeworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeworkController>(() => HomeworkController());
  }
}
