import 'package:get/get.dart';
import 'package:school_admin_app/pages/Staff/controllers/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StaffController>(() => StaffController());
  }
}
