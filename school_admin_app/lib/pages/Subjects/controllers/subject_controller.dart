import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:school_admin_app/graphql_config.dart';
import '../models/subject.dart';

class SubjectController extends GetxController {
  var subjects = <Subject>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchSubjects();
    super.onInit();
  }

  void fetchSubjects() async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const query = '''
        query {
          getSubjects {
            id
            name
            
          }
        }
      ''';

      final options = QueryOptions(document: gql(query));
      final result = await client.query(options);

      if (result.hasException) {
        throw result.exception!;
      }

      final data = result.data?['getSubjects'] as List<dynamic>;
      final subjectList =
          data.map((subject) => Subject.fromJson(subject)).toList();
      subjects.assignAll(subjectList);
    } catch (e) {
      print("Error fetching subjects: $e");
    } finally {
      isLoading(false);
    }
  }

  void addSubject(Subject subject) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation AddSubject(\$name: String!,) {
          addSubject(name: \$name, ) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: subject.toJson(),
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchSubjects();
    } catch (e) {
      print("Error adding subject: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteSubject(String id) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation DeleteSubject(\$id: ID!) {
          deleteSubject(id: \$id)
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

      fetchSubjects();
    } catch (e) {
      print("Error deleting subject: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateSubject(String id, Subject subject) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation UpdateSubject(\$id: ID!, \$name: String,) {
          updateSubject(id: \$id, name: \$name, ) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          ...subject.toJson(),
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchSubjects();
    } catch (e) {
      print("Error updating subject: $e");
    } finally {
      isLoading(false);
    }
  }
}
