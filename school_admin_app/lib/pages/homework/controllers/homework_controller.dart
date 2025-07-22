// // import 'package:get/get.dart';
// // import 'package:graphql_flutter/graphql_flutter.dart';
// // import 'package:school_admin_app/graphql_config.dart';
// // import 'package:school_admin_app/pages/homework/models/homework.dart';

// // class HomeworkController extends GetxController {
// //   final RxList<SubjectHomeworkEntry> subjectHomeworks = <SubjectHomeworkEntry>[].obs;

// //   var homeworkList = <Homework>[].obs;
// //   var isLoading = false.obs;

// //   @override
// //   void onInit() {
// //     fetchHomework();
// //     super.onInit();
// //   }

// //   void fetchHomework() async {
// //     isLoading(true);
// //     try {
// //       final client = await graphqlconfig();
// //       const query = '''
// //         query {
// //           getHomework {
// //             id
// //             classLevel
// //             subject
// //             homework

// //           }
// //         }
// //       ''';

// //       final options = QueryOptions(document: gql(query));
// //       final result = await client.query(options);

// //       if (result.hasException) {
// //         throw result.exception!;
// //       }

// //       final data = result.data?['getHomework'] as List<dynamic>;
// //       final homeworkListData =
// //           data.map((homework) => Homework.fromJson(homework)).toList();
// //       homeworkList.assignAll(homeworkListData);
// //     } catch (e) {
// //       print("Error fetching homework: $e");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   void addHomework(Homework homework) async {
// //     isLoading(true);
// //     try {
// //       final client = await graphqlconfig();
// //       const mutation = '''
// //         mutation AddHomework(\$classLevel: String!, \$subject: String!, \$homework: String!) {
// //           addHomework(classLevel: \$classLevel, subject: \$subject, homework: \$homework) {
// //             id
// //             classLevel
// //             subject
// //             homework
// //           }
// //         }
// //       ''';

// //       final options = MutationOptions(
// //         document: gql(mutation),
// //         variables: {
// //           'classLevel': homework.classLevel,
// //           'homework': homework.homework,
// //         },
// //       );

// //       final result = await client.mutate(options);

// //       if (result.hasException) {
// //         throw result.exception!;
// //       }

// //       final newHomework = Homework.fromJson(result.data!['addHomework']);
// //       homeworkList.add(newHomework);
// //     } catch (e) {
// //       print("Error adding homework: $e");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   void updateHomework(Homework homework) async {
// //     isLoading(true);
// //     try {
// //       final client = await graphqlconfig();
// //       const mutation = '''
// //         mutation UpdateHomework(\$id: String!, \$classLevel: String!, \$subject: String!, \$homework: String!) {
// //           updateHomework(id: \$id, classLevel: \$classLevel, subject: \$subject, homework: \$homework) {
// //             id
// //             classLevel
// //             subject
// //             homework
// //           }
// //         }
// //       ''';

// //       final options = MutationOptions(
// //         document: gql(mutation),
// //         variables: {
// //           'id': homework.id,
// //           'classLevel': homework.classLevel,
// //           'homework': homework.homework,
// //         },
// //       );

// //       final result = await client.mutate(options);

// //       if (result.hasException) {
// //         throw result.exception!;
// //       }

// //       final updatedHomework = Homework.fromJson(result.data!['updateHomework']);
// //       int index = homeworkList.indexWhere((h) => h.id == updatedHomework.id);
// //       if (index != -1) {
// //         homeworkList[index] = updatedHomework;
// //       }
// //     } catch (e) {
// //       print("Error updating homework: $e");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   void deleteHomework(String id) async {
// //     isLoading(true);
// //     try {
// //       final client = await graphqlconfig();
// //       const mutation = '''
// //         mutation DeleteHomework(\$id: String!) {
// //           deleteHomework(id: \$id)
// //         }
// //       ''';

// //       final options = MutationOptions(
// //         document: gql(mutation),
// //         variables: {'id': id},
// //       );

// //       final result = await client.mutate(options);

// //       if (result.hasException) {
// //         throw result.exception!;
// //       }

// //       homeworkList.removeWhere((homework) => homework.id == id);
// //     } catch (e) {
// //       print("Error deleting homework: $e");
// //     } finally {
// //       isLoading(false);
// //     }
// //   }
// // }
// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:school_admin_app/graphql_config.dart';
// import 'package:school_admin_app/pages/homework/models/homework.dart';

// class HomeworkController extends GetxController {
//   var subjectHomeworks = <SubjectHomeworkEntry>[].obs;
//   var homeworkList = <Homework>[].obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     fetchHomework();
//     super.onInit();
//   }

//   void fetchHomework() async {
//     isLoading(true);
//     try {
//       final client = await graphqlconfig();
//       const query = '''
//         query {
//           getHomework {
//             id
//             classLevel
//             subjectHomeworks {
//               subject
//               homework
//             }
//           }
//         }
//       ''';

//       final result = await client.query(QueryOptions(document: gql(query)));
//       if (result.hasException) throw result.exception!;
//       final data = result.data?['getHomework'] as List<dynamic>;
//       homeworkList.assignAll(data.map((e) => Homework.fromJson(e)).toList());
//     } catch (e) {
//       print("Error fetching homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void addHomework(Homework hw) async {
//     isLoading(true);
//     try {
//       final client = await graphqlconfig();
//       const mutation = '''
//         mutation AddHomework(\$classLevel: String!, \$subjectHomeworks: [SubjectHomeworkInput!]!) {
//           addHomework(classLevel: \$classLevel, subjectHomeworks: \$subjectHomeworks) {
//             id
//             classLevel
//             subjectHomeworks {
//               subject
//               homework
//             }
//           }
//         }
//       ''';

//       final result = await client.mutate(MutationOptions(
//         document: gql(mutation),
//         variables: {
//           'classLevel': hw.classLevel,
//           'subjectHomeworks':
//               hw.subjectHomeworks.map((e) => e.toJson()).toList(),
//         },
//       ));

//       if (result.hasException) throw result.exception!;
//       final newHomework = Homework.fromJson(result.data!['addHomework']);
//       homeworkList.add(newHomework);

//       // ✅ Send FCM notification to the class topic
//       await sendHomeworkNotification(hw.classLevel);
//     } catch (e) {
//       print("Error adding homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void deleteHomework(String id) async {
//     isLoading(true);
//     try {
//       final client = await graphqlconfig();
//       const mutation = '''
//         mutation DeleteHomework(\$id: String!) {
//           deleteHomework(id: \$id)
//         }
//       ''';

//       await client.mutate(MutationOptions(
//         document: gql(mutation),
//         variables: {'id': id},
//       ));

//       homeworkList.removeWhere((e) => e.id == id);
//     } catch (e) {
//       print("Error deleting homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   Future<void> sendHomeworkNotificationToClass({
//     required String classLevel,
//     required String title,
//     required String body,
//   }) async {
//     final serverKey = dotenv.env['FCM_SERVER_KEY']; // 🔒 Secure this!
//     final String topic = 'class-$classLevel';

//     final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     };

//     final payload = {
//       'to': '/topics/$topic',
//       'notification': {
//         'title': title,
//         'body': body,
//       },
//       'priority': 'high',
//     };

//     final response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 200) {
//       print('✅ Notification sent to class-$classLevel');
//     } else {
//       print('❌ Failed to send notification: ${response.body}');
//     }
//   }

//   Future<void> sendHomeworkNotification(String classLevel) async {
//     final serverKey = dotenv.env['FCM_SERVER_KEY'];
//     // 🔐 Use from Firebase project settings
//     final topic = 'class-$classLevel'; // e.g., class-5D

//     final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

//     final message = {
//       'to': '/topics/$topic',
//       'notification': {
//         'title': '📘 New Homework Posted',
//         'body': 'Homework has been added for class $classLevel',
//       },
//       'android': {
//         'priority': 'high',
//       },
//       'data': {
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//       }
//     };

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$serverKey',
//       },
//       body: json.encode(message),
//     );

//     if (response.statusCode == 200) {
//       print('✅ Homework notification sent to $topic');
//     } else {
//       print('❌ Failed to send notification: ${response.body}');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:school_admin_app/graphql_config.dart';
import 'package:school_admin_app/pages/homework/models/homework.dart';

class HomeworkController extends GetxController {
  var subjectHomeworks = <SubjectHomeworkEntry>[].obs;
  var homeworkList = <Homework>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchHomework();
    super.onInit();
  }

  void fetchHomework() async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const query = '''
        query {
          getHomework {
            id
            classLevel
            subjectHomeworks {
              subject
              homework
            }
          }
        }
      ''';

      final result = await client.query(QueryOptions(document: gql(query)));
      if (result.hasException) throw result.exception!;
      final data = result.data?['getHomework'] as List<dynamic>;
      homeworkList.assignAll(data.map((e) => Homework.fromJson(e)).toList());
    } catch (e) {
      print("Error fetching homework: $e");
    } finally {
      isLoading(false);
    }
  }

  void addHomework(Homework hw) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation AddHomework(\$classLevel: String!, \$subjectHomeworks: [SubjectHomeworkInput!]!) {
          addHomework(classLevel: \$classLevel, subjectHomeworks: \$subjectHomeworks) {
            id
            classLevel
            subjectHomeworks {
              subject
              homework
            }
          }
        }
      ''';

      final result = await client.mutate(MutationOptions(
        document: gql(mutation),
        variables: {
          'classLevel': hw.classLevel,
          'subjectHomeworks':
              hw.subjectHomeworks.map((e) => e.toJson()).toList(),
        },
      ));

      if (result.hasException) throw result.exception!;
      final newHomework = Homework.fromJson(result.data!['addHomework']);
      homeworkList.add(newHomework);
      await sendHomeworkNotification(hw.classLevel);
    } catch (e) {
      print("Error adding homework: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendHomeworkNotification(String classLevel) async {
    final serverKey = dotenv.env['FCM_SERVER_KEY'];
    final topic = 'class-$classLevel';
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/schoolapp-7e694/messages:send"');

    final message = {
      'to': '/topics/$topic',
      'notification': {
        'title': '📘 New Homework Posted',
        'body': 'Homework has been added for class $classLevel',
      },
      'android': {'priority': 'high'},
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'}
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print('✅ Homework notification sent to $topic');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }
  }

  void deleteHomework(String id) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation DeleteHomework(\$id: ID!) {
          deleteHomework(id: \$id)
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {'id': id},
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      homeworkList.removeWhere((homework) => homework.id == id);
    } catch (e) {
      print("Error deleting homework: $e");
    } finally {
      isLoading(false);
    }
  }
}
