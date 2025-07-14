import 'package:get/get.dart';
import 'package:school_parent_app/pages/ParentDashboard/screens/parent_dashboard_screen.dart';
import 'package:school_parent_app/pages/Students/screens/student_profile.dart';
import 'package:school_parent_app/pages/UserAuthentication/bindings/user_auth_binding.dart';
import 'package:school_parent_app/pages/UserAuthentication/user_auth_screen.dart';
import 'package:school_parent_app/pages/homework/binding/homework_binding.dart';
import 'package:school_parent_app/pages/homework/screens/homework_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String profile = '/profile';
  static const String parent_dashboard_screen = '/parent_dashboard_screen';
  static const homeworkScreen = '/homework';

  static String initialRoute = '/';
  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => UserAuthenticationScreen(),
      bindings: [UserAuthBinding()],
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: parent_dashboard_screen,
      page: () => ParentDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.homeworkScreen,
      page: () => HomeworkScreen(),
      binding: HomeworkBinding(),
    ),
  ];
}
