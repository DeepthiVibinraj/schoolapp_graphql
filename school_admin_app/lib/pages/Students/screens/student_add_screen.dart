import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/Class/models/class.dart';
import '../controllers/student_controller.dart';
import '../models/student.dart';

class AddStudentScreen extends StatelessWidget {
  final StudentController studentController = Get.find();
  final ClassController classController = Get.put(ClassController());

  final Student? student;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final Rxn<Class> selectedClass = Rxn<Class>();

  AddStudentScreen({super.key, this.student}) {
    if (student != null) {
      nameController.text = student!.name;
      ageController.text = student!.age.toString();
      contactController.text = student!.contact;
      emailController.text = student!.email;

      // This sets the selected class based on the student's current class name
      classController.onInit(); // Ensures the class list is fetched
      ever(classController.classes, (_) {
        final matched = classController.classes.firstWhereOrNull(
          (cls) => cls.name == student!.studentClass,
        );
        selectedClass.value = matched;
      });
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
        child: Obx(() {
          if (classController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter age';
                    if (int.tryParse(value) == null)
                      return 'Age must be number';
                    return null;
                  },
                ),
                DropdownButtonFormField<Class>(
                  value: selectedClass.value,
                  decoration: InputDecoration(labelText: 'Class'),
                  items: classController.classes.map((cls) {
                    return DropdownMenuItem<Class>(
                      value: cls,
                      child: Text(cls.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedClass.value = value;
                  },
                  validator: (value) =>
                      value == null ? 'Please select a class' : null,
                ),
                TextFormField(
                  controller: contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Enter contact' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newStudent = Student(
                        id: student?.id ?? '',
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        studentClass: selectedClass.value!.name,
                        contact: contactController.text,
                        email: emailController.text,
                      );

                      if (student == null) {
                        studentController.addStudent(newStudent);
                      } else {
                        studentController.updateStudent(
                            student!.id, newStudent);
                      }

                      Get.back();
                    }
                  },
                  child:
                      Text(student == null ? 'Add Student' : 'Update Student'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
