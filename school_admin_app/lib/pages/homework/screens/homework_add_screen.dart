// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
// import 'package:school_admin_app/pages/Subjects/controllers/subject_controller.dart';
// import 'package:school_admin_app/pages/homework/controllers/homework_controller.dart';
// import 'package:school_admin_app/pages/homework/models/homework.dart';

// class AddHomeworkScreen extends StatelessWidget {
//   AddHomeworkScreen({super.key});
//   final ClassController classController = Get.put(ClassController());
//   final SubjectController subjectController = Get.put(SubjectController());
//   final HomeworkController homeworkController = Get.put(HomeworkController());

//   final RxnString selectedClass = RxnString();
//   final RxnString selectedSubject = RxnString();
//   TextEditingController hwController = TextEditingController();
//   void _addSubject() {
//     homeworkController.subjectHomeworks.add(
//       SubjectHomeworkEntry(),
//     );
//   }

//   void _submitHomework() {
//     for (var entry in homeworkController.subjectHomeworks) {
//       print(
//           "Subject: ${entry.subjectName.value}, Homework: ${entry.homework.text}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Homework'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Obx(() => Column(
//                   children: List.generate(
//                       homeworkController.subjectHomeworks.length, (index) {
//                     final entry = homeworkController.subjectHomeworks[index];
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         children: [
//                           // Subject Dropdown
//                           DropdownButton<String>(
//                             value: entry.subjectName.value,
//                             hint: Text('Select Subject'),
//                             onChanged: (newValue) {
//                               entry.subjectName.value = newValue!;
//                             },
//                             items: subjectController.subjects.map((subjectObj) {
//                               return DropdownMenuItem<String>(
//                                 value: subjectObj.name,
//                                 child: Text(subjectObj.name),
//                               );
//                             }).toList(),
//                           ),
//                           SizedBox(width: 8),

//                           // Homework TextField
//                           Expanded(
//                             child: TextField(
//                               controller: entry.homework,
//                               decoration: InputDecoration(
//                                 labelText: 'Homework',
//                                 border: OutlineInputBorder(),
//                               ),
//                               maxLines: 3,
//                             ),
//                           ),
//                           SizedBox(width: 8),

//                           // Delete button
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               homeworkController.subjectHomeworks
//                                   .removeAt(index);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//                 )),
//           ),
//           SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: _addSubject,
//             child: Text('Add Subject'),
//           ),
//           ElevatedButton(
//             onPressed: _submitHomework,
//             child: Text('Add Homework'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/Subjects/controllers/subject_controller.dart';
import 'package:school_admin_app/pages/homework/controllers/homework_controller.dart';
import 'package:school_admin_app/pages/homework/models/homework.dart';

class AddHomeworkScreen extends StatelessWidget {
  AddHomeworkScreen({super.key});

  final ClassController classController = Get.put(ClassController());
  final SubjectController subjectController = Get.put(SubjectController());
  final HomeworkController homeworkController = Get.put(HomeworkController());

  final RxnString selectedClass = RxnString();

  void _addSubject() {
    homeworkController.subjectHomeworks.add(SubjectHomeworkEntry());
  }

  void _submitHomework() {
    if (selectedClass.value == null) {
      Get.snackbar("Error", "Please select a class",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final entries = homeworkController.subjectHomeworks;
    final List<SubjectHomework> subjectList = [];

    for (var entry in entries) {
      if (entry.subject.value != null &&
          entry.homework.text.trim().isNotEmpty) {
        subjectList.add(SubjectHomework(
          subject: entry.subject.value!,
          homework: entry.homework.text.trim(),
        ));
      }
    }

    if (subjectList.isEmpty) {
      Get.snackbar("Error", "Add at least one subject homework",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final hw = Homework(
      id: '',
      classLevel: selectedClass.value!,
      subjectHomeworks: subjectList,
    );

    homeworkController.addHomework(hw);
    selectedClass.value = null;
    for (var entry in homeworkController.subjectHomeworks) {
      entry.homework.clear();
    }
    homeworkController.subjectHomeworks.clear();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Homework')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => DropdownButton<String>(
                  isExpanded: true,
                  value: selectedClass.value,
                  hint: Text('Select Class'),
                  onChanged: (val) => selectedClass.value = val,
                  items: classController.classes
                      .map((e) => DropdownMenuItem<String>(
                            value: e.id,
                            child: Text(e.name),
                          ))
                      .toList(),
                )),
            SizedBox(height: 16),
            Obx(() => Column(
                  children: List.generate(
                      homeworkController.subjectHomeworks.length, (index) {
                    final entry = homeworkController.subjectHomeworks[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            value: entry.subject.value,
                            hint: Text('Select Subject'),
                            onChanged: (val) => entry.subject.value = val!,
                            items: subjectController.subjects
                                .map((s) => DropdownMenuItem<String>(
                                      value: s.name,
                                      child: Text(s.name),
                                    ))
                                .toList(),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: entry.homework,
                              decoration: InputDecoration(
                                labelText: 'Homework',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => homeworkController.subjectHomeworks
                                .removeAt(index),
                          )
                        ],
                      ),
                    );
                  }),
                )),
            ElevatedButton.icon(
              onPressed: _addSubject,
              icon: Icon(Icons.add),
              label: Text('Add Subject'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitHomework,
              child: Text('Submit Homework'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 48),
              ),
            )
          ],
        ),
      ),
    );
  }
}
