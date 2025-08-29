import 'package:get/get.dart';
import 'package:school_admin_app/pages/Events/controllers/event_controller.dart';

class EventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}
