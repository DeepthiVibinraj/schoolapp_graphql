import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';

class ClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassController>(() => ClassController());
  }
}
