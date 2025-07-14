import 'package:get/get.dart';
import 'package:school_admin_app/pages/homework/controllers/homework_controller.dart';

class HomeworkBinding extends Bindings {
  @override
  void dependencies() {
    // Here you can register your dependencies for the Homework feature
    // For example:
    Get.lazyPut<HomeworkController>(() => HomeworkController());
  }
}
