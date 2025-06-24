import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../models/timetable.dart';

class TimetableController extends GetxController {
  var isLoading = false.obs;
  var timetable = Rxn<TimeTable>(); // Nullable to handle absence of data

  final String className;

  TimetableController(this.className);
  @override
  void onInit() {
    super.onInit();
    fetchTimetable(); // Fetch timetable when the controller is initialized
  }

  void fetchTimetable() async {
    isLoading(true);
    try {
      final client = GraphQLClient(
        link: HttpLink('http://localhost:4000/graphql'),
        cache: GraphQLCache(),
      );

      const String query = '''
      query GetTimetableByClass(\$className: String!) {
        getTimetableByClass(className: \$className) {
          className
          schedule {
            day
            periods
          }
        }
      }
    ''';

      print('Fetching timetable for className: $className'); // Debug
      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'className': className},
        ),
      );

      if (result.hasException) {
        print(
            'GraphQL Exception: ${result.exception.toString()}'); // Log exceptions
        return;
      }

      final data = result.data?['getTimetableByClass'];
      print('GraphQL Response: $data'); // Log raw response

      if (data != null) {
        timetable.value = TimeTable.fromJson(data);
        print('Parsed Timetable: ${timetable.value}');
      } else {
        print('No timetable found for className: $className');
        timetable.value = null;
      }
    } finally {
      isLoading(false);
    }
  }
}
