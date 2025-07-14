import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subject_controller.dart';
import '../models/subject.dart';

class AddSubjectScreen extends StatelessWidget {
  final SubjectController subjectController = Get.find();

  final Subject? subject;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  AddSubjectScreen({this.subject}) {
    if (subject != null) {
      nameController.text = subject!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newSubject = Subject(
                      id: subject?.id ?? '',
                      name: nameController.text,
                    );

                    if (subject == null) {
                      subjectController.addSubject(newSubject);
                    } else {
                      subjectController.updateSubject(subject!.id, newSubject);
                    }

                    Get.back();
                  }
                },
                child: Text(subject == null ? 'Add Subject' : 'Update Subject'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
