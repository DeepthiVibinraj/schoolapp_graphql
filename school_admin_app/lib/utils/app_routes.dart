import 'package:get/get.dart';
import 'package:school_admin_app/core/theme/common_components/page_under_construction.dart';
import 'package:school_admin_app/pages/admin_dashboard/bindings/admin_dashboard_binding.dart';
import 'package:school_admin_app/pages/admin_dashboard/screens/admin_dashboard_screen.dart';
import 'package:school_admin_app/pages/Class/bindings/class_binding.dart';
import 'package:school_admin_app/pages/Class/screens/class_add_screen.dart';
import 'package:school_admin_app/pages/Class/screens/class_list_screen.dart';
import 'package:school_admin_app/pages/Staff/bindings/staff_binding.dart';
import 'package:school_admin_app/pages/Staff/screens/staff_add_screen.dart';
import 'package:school_admin_app/pages/Staff/screens/staff_list_screen.dart';
import 'package:school_admin_app/pages/Students/bindings/student_binding.dart';
import 'package:school_admin_app/pages/Students/screens/student_add_screen.dart';
import 'package:school_admin_app/pages/Students/screens/student_list_screen.dart';
import 'package:school_admin_app/pages/Subjects/screens/subject_add_screen.dart';
import 'package:school_admin_app/pages/Subjects/screens/subject_list_screen.dart';
import 'package:school_admin_app/pages/TimeTable/bindings/timetable_binding.dart';
import 'package:school_admin_app/pages/TimeTable/screens/timetable_add_screen.dart';
import 'package:school_admin_app/pages/TimeTable/screens/timetable_list_screen.dart';
import 'package:school_admin_app/pages/UserAuthentication/bindings/user_auth_binding.dart';
import 'package:school_admin_app/pages/UserAuthentication/user_auth_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String admin_dashboard_screen = '/admin_dashboard_screen';
  static const String student_list_screen = '/student_list_screen';
  static const String student_add_screen = '/student_add_screen';
  static const String staff_list_screen = '/staff_list_screen';
  static const String staff_add_screen = '/staff_add_screen';
  static const String subject_list_screen = '/subject_list_screen';
  static const String subject_add_screen = '/subject_add_screen';
  static const String class_list_screen = '/class_list_screen';
  static const String class_add_screen = '/class_add_screen';
  static const String timetable_list_screen = '/timetable_list_screen';
  static const String timetable_add_screen = '/timetable_add_screen';
  static const String page_under_construction = '/page_under_construction';

  static String initialRoute = '/';
  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => UserAuthenticationScreen(),
      bindings: [UserAuthBinding()],
    ),
    // GetPage(
    //   name: admin_dashboard_screen,
    //   page: () => AdminDashboardScreen(),
    //   bindings: [AdminDashboardBinding()],
    // ),
    GetPage(
      name: student_list_screen,
      page: () => StudentListScreen(),
      bindings: [StudentBinding()],
    ),
    GetPage(
      name: student_add_screen,
      page: () => AddStudentScreen(),
      bindings: [StudentBinding()],
    ),
    GetPage(
      name: staff_list_screen,
      page: () => StaffListScreen(),
      bindings: [StaffBinding()],
    ),
    GetPage(
      name: staff_add_screen,
      page: () => AddStaffScreen(),
      bindings: [StaffBinding()],
    ),
    GetPage(
      name: subject_list_screen,
      page: () => SubjectListScreen(),
      bindings: [StaffBinding()],
    ),
    GetPage(
      name: subject_add_screen,
      page: () => AddSubjectScreen(),
      bindings: [StaffBinding()],
    ),
    GetPage(
      name: class_list_screen,
      page: () => ClassListScreen(),
      bindings: [ClassBinding()],
    ),
    GetPage(
      name: class_add_screen,
      page: () => AddClassScreen(),
      bindings: [ClassBinding()],
    ),
    GetPage(
      name: timetable_list_screen,
      page: () => TimeTableListScreen(),
      bindings: [ClassBinding()],
    ),
    GetPage(
      name: timetable_add_screen,
      page: () => AddTimeTableScreen(),
      bindings: [TimeTableBinding()],
    ),
    GetPage(
      name: page_under_construction,
      page: () => PageUnderConstruction(),
      bindings: [TimeTableBinding()],
    ),
  ];
}
