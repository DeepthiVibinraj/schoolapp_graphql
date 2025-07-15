// import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:school_parent_app/graphql_config.dart';
// import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';

// class ParentDashboardController extends GetxController {
//   var isActive = false.obs;
//   final FirebaseMessaging messaging = FirebaseMessaging.instance;

//   @override
//   void onInit() {
//     super.onInit();
//     initializeFCM();
//   }

//   Future<void> initializeFCM() async {
//     NotificationSettings settings = await messaging.requestPermission();

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       String? token = await messaging.getToken();
//       print("🔑 FCM Token: $token");

//       if (token != null) {
//         await sendFcmTokenToBackend(token);
//       }
//     }

//     FirebaseMessaging.onMessage.listen((message) {
//       print('📩 Notification Received: ${message.notification?.title}');
//     });
//   }

//   Future<void> sendFcmTokenToBackend(String token) async {
//     const String saveFcmTokenMutation = """
//       mutation SaveToken(\$studentId: ID!, \$token: String!) {
//         saveParentFcmToken(studentId: \$studentId, token: \$token)
//       }
//     """;
//     final studentController = Get.find<StudentController>();
//     final studentId = studentController
//         .students[studentController.activeStudentIndex.value].id;

//     final client =
//         await graphqlconfig(); // Replace with actual studentId from state or storage

//     final MutationOptions options = MutationOptions(
//       document: gql(saveFcmTokenMutation),
//       variables: {
//         'studentId': studentId,
//         'token': token,
//       },
//     );

//     final result = await Get.find<GraphQLClient>().mutate(options);

//     if (result.hasException) {
//       print('❌ Error saving FCM token: ${result.exception.toString()}');
//     } else {
//       print('✅ FCM token saved successfully');
//     }
//   }
// }
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:school_parent_app/graphql_config.dart';
import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';

class ParentDashboardController extends GetxController {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final RxString fcmToken = ''.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();

    initializeFCM();

    // 👇 Add listener to detect when the parent switches children
    final studentController = Get.find<StudentController>();
    studentController.activeStudentIndex.listen((index) {
      if (fcmToken.isNotEmpty && studentController.students.isNotEmpty) {
        sendFcmTokenToBackend(fcmToken.value);
      }
    });
  }

  Future<void> initializeFCM() async {
    print("🔥 initializeFCM called");
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await messaging.getToken();
      print('🔑 Parent FCM token: $token');
      if (token != null) {
        print('🔑 Parent FCM token: $token');
        fcmToken.value = token;
        // 👇 Subscribe parent to a common topic like "allParents"
        //await FirebaseMessaging.instance.subscribeToTopic('allParents');
        await FirebaseMessaging.instance.subscribeToTopic('allParents');
        print("✅ Subscribed to topic: allParents");

        await sendFcmTokenToBackend(token);
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Default Channel',
              channelDescription: 'For foreground messages',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // FirebaseMessaging.onMessage.listen((message) {
    //   print("📩 Foreground Notification Received");
    //   print("Title: ${message.notification?.title}");
    //   print("Body: ${message.notification?.body}");
    //   //print("📩 Foreground Notification: ${message.notification?.title}");
    // });
  }

  Future<void> sendFcmTokenToBackend(String token) async {
    final studentController = Get.find<StudentController>();

    if (studentController.students.isEmpty) return;

    final studentId = studentController
        .students[studentController.activeStudentIndex.value].id;

    const String mutation = """
      mutation SaveToken(\$studentId: ID!, \$token: String!) {
        saveParentFcmToken(studentId: \$studentId, token: \$token)
      }
    """;

    final client = await graphqlconfig();

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: {
        'studentId': studentId,
        'token': token,
      },
    ));

    if (result.hasException) {
      print("❌ Error sending FCM token: ${result.exception.toString()}");
    } else {
      print("✅ FCM token sent successfully for student: $studentId");
    }
  }
}
