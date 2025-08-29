import 'package:school_admin_app/core/constants/image_constant.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class GridMenuModel {
  GridMenuModel(this.image, this.menuName, this.route);
  String menuName;
  String image;
  String route;
}

List<GridMenuModel> menus = [
  GridMenuModel(
      ImageConstant.students, 'Students', AppRoutes.student_list_screen),
  GridMenuModel(ImageConstant.staff, 'Staff', AppRoutes.staff_list_screen),
  GridMenuModel(
      ImageConstant.subject, 'Subject', AppRoutes.subject_list_screen),
  GridMenuModel(ImageConstant.classes, 'Class', AppRoutes.class_list_screen),
  GridMenuModel(
      ImageConstant.timetable, 'Time Table', AppRoutes.timetable_list_screen),
];
