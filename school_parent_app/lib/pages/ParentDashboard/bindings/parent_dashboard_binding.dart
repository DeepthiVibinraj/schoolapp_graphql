import 'package:get/get.dart';
import 'package:school_parent_app/pages/ParentDashboard/controllers/parent_dashboard_controller.dart';

class ParentDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentDashboardController>(() => ParentDashboardController());
  }
}
