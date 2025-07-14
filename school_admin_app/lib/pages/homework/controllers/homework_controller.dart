// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:school_admin_app/graphql_config.dart';
// import 'package:school_admin_app/pages/homework/models/homework.dart';

// class HomeworkController extends GetxController {
//   final RxList<SubjectHomeworkEntry> subjectHomeworks = <SubjectHomeworkEntry>[].obs;

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
//             subject
//             homework

//           }
//         }
//       ''';

//       final options = QueryOptions(document: gql(query));
//       final result = await client.query(options);

//       if (result.hasException) {
//         throw result.exception!;
//       }

//       final data = result.data?['getHomework'] as List<dynamic>;
//       final homeworkListData =
//           data.map((homework) => Homework.fromJson(homework)).toList();
//       homeworkList.assignAll(homeworkListData);
//     } catch (e) {
//       print("Error fetching homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void addHomework(Homework homework) async {
//     isLoading(true);
//     try {
//       final client = await graphqlconfig();
//       const mutation = '''
//         mutation AddHomework(\$classLevel: String!, \$subject: String!, \$homework: String!) {
//           addHomework(classLevel: \$classLevel, subject: \$subject, homework: \$homework) {
//             id
//             classLevel
//             subject
//             homework
//           }
//         }
//       ''';

//       final options = MutationOptions(
//         document: gql(mutation),
//         variables: {
//           'classLevel': homework.classLevel,
//           'homework': homework.homework,
//         },
//       );

//       final result = await client.mutate(options);

//       if (result.hasException) {
//         throw result.exception!;
//       }

//       final newHomework = Homework.fromJson(result.data!['addHomework']);
//       homeworkList.add(newHomework);
//     } catch (e) {
//       print("Error adding homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   void updateHomework(Homework homework) async {
//     isLoading(true);
//     try {
//       final client = await graphqlconfig();
//       const mutation = '''
//         mutation UpdateHomework(\$id: String!, \$classLevel: String!, \$subject: String!, \$homework: String!) {
//           updateHomework(id: \$id, classLevel: \$classLevel, subject: \$subject, homework: \$homework) {
//             id
//             classLevel
//             subject
//             homework
//           }
//         }
//       ''';

//       final options = MutationOptions(
//         document: gql(mutation),
//         variables: {
//           'id': homework.id,
//           'classLevel': homework.classLevel,
//           'homework': homework.homework,
//         },
//       );

//       final result = await client.mutate(options);

//       if (result.hasException) {
//         throw result.exception!;
//       }

//       final updatedHomework = Homework.fromJson(result.data!['updateHomework']);
//       int index = homeworkList.indexWhere((h) => h.id == updatedHomework.id);
//       if (index != -1) {
//         homeworkList[index] = updatedHomework;
//       }
//     } catch (e) {
//       print("Error updating homework: $e");
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

//       final options = MutationOptions(
//         document: gql(mutation),
//         variables: {'id': id},
//       );

//       final result = await client.mutate(options);

//       if (result.hasException) {
//         throw result.exception!;
//       }

//       homeworkList.removeWhere((homework) => homework.id == id);
//     } catch (e) {
//       print("Error deleting homework: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
    } catch (e) {
      print("Error adding homework: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteHomework(String id) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation DeleteHomework(\$id: String!) {
          deleteHomework(id: \$id)
        }
      ''';

      await client.mutate(MutationOptions(
        document: gql(mutation),
        variables: {'id': id},
      ));

      homeworkList.removeWhere((e) => e.id == id);
    } catch (e) {
      print("Error deleting homework: $e");
    } finally {
      isLoading(false);
    }
  }
}
