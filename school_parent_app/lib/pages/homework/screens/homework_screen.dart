import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';
import 'package:school_parent_app/pages/homework/controllers/homework_controller.dart';

import 'package:school_parent_app/pages/homework/models/homework_model.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final HomeworkController homeworkController = Get.find<HomeworkController>();
  final StudentController studentController = Get.put(StudentController());
  @override
  void initState() {
    super.initState();
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    // Watch for student change
    ever(studentController.activeStudentIndex, (index) {
      homeworkController.fetchHomeworkForCurrentUser(email, index);
    });

    // Initial fetch
    final activeIndex = studentController.activeStudentIndex.value;
    homeworkController.fetchHomeworkForCurrentUser(email, activeIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Homeworks"),
        backgroundColor: colorScheme.primary,
      ),
      body: Obx(() {
        if (homeworkController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (homeworkController.homeworkList.isEmpty) {
          return const Center(child: Text("No homework available."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: homeworkController.homeworkList.length,
          itemBuilder: (context, index) {
            final Homework homework = homeworkController.homeworkList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Class: ${homework.classLevel}",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...homework.subjectHomeworks.map(
                      (subjectHW) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subjectHW.subject,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              subjectHW.homework,
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
