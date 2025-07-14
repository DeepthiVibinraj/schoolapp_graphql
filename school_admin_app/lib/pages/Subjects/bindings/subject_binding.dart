import 'package:get/get.dart';
import 'package:school_admin_app/pages/Subjects/controllers/subject_controller.dart';

class SubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectController>(() => SubjectController());
  }
}
