import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:school_admin_app/graphql_config.dart';
import '../models/class.dart';

class ClassController extends GetxController {
  var classes = <Class>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchClasses();
    super.onInit();
  }

  void fetchClasses() async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const query = '''
        query {
          getClasses {
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

      final data = result.data?['getClasses'] as List<dynamic>;
      final classList = data.map((classs) => Class.fromJson(classs)).toList();
      classes.assignAll(classList);
    } catch (e) {
      print("Error fetching class: $e");
    } finally {
      isLoading(false);
    }
  }

  void addClass(Class classs) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation AddClass(\$name: String!, ) {
          addClass(name: \$name, ) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: classs.toJson(),
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchClasses();
    } catch (e) {
      print("Error adding class: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteClass(String id) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation DeleteClass(\$id: ID!) {
          deleteSClass(id: \$id)
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

      fetchClasses();
    } catch (e) {
      print("Error deleting class: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateStaff(String id, Class classs) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation UpdateClass(\$id: ID!, \$name: String, ) {
          updateClass(id: \$id, name: \$name,) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          ...classs.toJson(),
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchClasses();
    } catch (e) {
      print("Error updating class: $e");
    } finally {
      isLoading(false);
    }
  }
}
