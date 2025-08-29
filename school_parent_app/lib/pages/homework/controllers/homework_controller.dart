import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_parent_app/graphql_config.dart';
import 'package:school_parent_app/pages/homework/models/homework_model.dart';

class HomeworkController extends GetxController {
  var homeworks = <Homework>[].obs;
  var isLoading = false.obs;

  final client = Get.find<GraphQLClient>();

  var homeworkList = <Homework>[].obs;

  Future<void> fetchHomeworkForCurrentUser(
      String email, int activeIndex) async {
    isLoading(true);
    print('-------------------');
    print('Fetching homework for email: $email, activeIndex: $activeIndex');

    try {
      const studentQuery = r'''
      query GetStudentByEmail($email: String!) {
        getStudentByEmail(email: $email) {
          id
          name
          class
        }
      }
    ''';

      final studentResult = await client.query(
        QueryOptions(
          document: gql(studentQuery),
          variables: {'email': email},
        ),
      );

      if (studentResult.hasException) {
        print(' GraphQL Error: ${studentResult.exception.toString()}');
        homeworkList.clear();
        return;
      }

      final students = studentResult.data?['getStudentByEmail'];
      print(' Students: $students');

      if (students == null ||
          students.isEmpty ||
          activeIndex >= students.length) {
        homeworkList.clear();
        print(" No valid student found");
        return;
      }

      final selectedStudent = students[activeIndex];
      final String classLevel = selectedStudent['class'] ?? '';
      print('Selected Class Level: $classLevel');

      const homeworkQuery = r'''
      query GetHomeworkByClassLevel($classLevel: String!) {
        getHomeworkByClassLevel(classLevel: $classLevel) {
          classLevel
          subjectHomeworks {
            subject
            homework
          }
        }
      }
    ''';

      final homeworkResult = await client.query(
        QueryOptions(
          document: gql(homeworkQuery),
          variables: {'classLevel': classLevel},
        ),
      );

      if (homeworkResult.hasException) {
        print(
            'Error fetching homework: ${homeworkResult.exception.toString()}');
        homeworkList.clear();
        return;
      }
      homeworkList.value = List<Homework>.from(
        (homeworkResult.data?['getHomeworkByClassLevel'] ?? [])
            .map((e) => Homework.fromJson(e)),
      );

      print(' Homework List: ${homeworkList.length}');
    } catch (e) {
      print(' Exception: $e');
      homeworkList.clear();
    } finally {
      isLoading(false);
    }
  }

  ///  2. Fetch homework by providing class name directly (e.g., from dropdown)
  Future<void> fetchHomework(String className) async {
    final GraphQLClient client = await graphqlconfig();
    Get.put<GraphQLClient>(client);
    print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');

    const String query = r'''
      query GetHomeworkByClassLevel($classLevel: String!) {
        getHomeworkByClassLevel(classLevel: $classLevel) {
          id
          classLevel
          subjectHomeworks {
            subject
            homework
          }
        }
      }
    ''';

    try {
      isLoading(true);
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'classLevel': className},
      ));

      if (result.hasException) {
        print(' Error: ${result.exception.toString()}');
        homeworks.clear();
        return;
      }
      print('++++++++++++++++++++++++++++++++++++++++++++');

      print('Result: ${result.data}');

      final data = result.data?['getHomeworkByClassLevel'] ?? [];
      if (data == null || data.isEmpty) {
        print(' No homework data for class: $className');
        homeworks.clear();
        return;
      }
      homeworks.assignAll(
        List<Homework>.from(data.map((e) => Homework.fromJson(e))),
      );

      print(' Homework fetched: ${homeworks.length}');
    } finally {
      isLoading(false);
    }
  }
}
