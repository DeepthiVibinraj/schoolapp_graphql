import 'package:get/get.dart';
import 'package:school_admin_app/pages/Students/controllers/student_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentController>(() => StudentController());
  }
}
