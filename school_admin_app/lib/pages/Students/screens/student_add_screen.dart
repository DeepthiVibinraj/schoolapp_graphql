import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';

class AddStudentScreen extends StatelessWidget {
  final StudentController studentController = Get.find();

  final Student? student;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  AddStudentScreen({this.student}) {
    if (student != null) {
      nameController.text = student!.name;
      ageController.text = student!.age.toString();
      classController.text = student!.studentClass;
      contactController.text = student!.contact;
      emailController.text = student!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
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
                    return 'Please enter the student\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student\'s age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Age must be a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: classController,
                decoration: InputDecoration(labelText: 'Class'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the class';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newStudent = Student(
                      id: student?.id ?? '',
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      studentClass: classController.text,
                      contact: contactController.text,
                      email: emailController.text,
                    );

                    if (student == null) {
                      studentController.addStudent(newStudent);
                    } else {
                      studentController.updateStudent(student!.id, newStudent);
                    }

                    Get.back();
                  }
                },
                child: Text(student == null ? 'Add Student' : 'Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
