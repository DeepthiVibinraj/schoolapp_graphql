import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/TimeTable/controllers/timetable_controller.dart';

class TimeTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeTableController>(() => TimeTableController());
    Get.lazyPut<ClassController>(() => ClassController());
  }
}
