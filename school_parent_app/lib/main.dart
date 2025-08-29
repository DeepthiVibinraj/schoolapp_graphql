import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_parent_app/core/theme/app_theme_data.dart';
import 'package:school_parent_app/firebase_options.dart';
import 'package:school_parent_app/graphql_config.dart';
import 'utils/app_routes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;

  String initialRoute;

  if (currentUser != null) {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    String? role = doc.data()?['userRole'] ?? 'admin';

    if (role == 'parent') {
      initialRoute = AppRoutes.parent_dashboard_screen;
    } else {
      initialRoute = AppRoutes.login;
    }
  } else {
    initialRoute = AppRoutes.login;
  }

  runApp(MyApp(initialRoute: initialRoute));
  // Foreground notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  final GraphQLClient client = await graphqlconfig();
  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put<GraphQLClient>(client);
  runApp(MyApp(initialRoute: initialRoute));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'School Parent App',
      theme: AppThemeData.lightThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      darkTheme: AppThemeData.darkThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
