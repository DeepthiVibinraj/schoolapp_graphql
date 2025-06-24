import 'package:get/get.dart';
import 'package:school_parent_app/pages/UserAuthentication/controllers/user_auth_controller.dart';

class UserAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserAuthenticationController>(
        () => UserAuthenticationController());
  }
}
