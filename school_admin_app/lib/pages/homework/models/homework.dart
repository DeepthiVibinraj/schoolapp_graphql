// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Homework {
//   final String id;
//   final String classLevel;
//   final String homework;
//   Homework({
//     required this.id,
//     required this.classLevel,
//     required this.homework,
//   });
//   factory Homework.fromJson(Map<String, dynamic> json) {
//     return Homework(
//       id: json['id'] as String,
//       classLevel: json['classLevel'] as String,
//       homework: json['homework'] as String,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'classLevel': classLevel,
//       'homework': homework,
//     };
//   }
// }

// class SubjectHomeworkEntry {
//   RxnString subjectName = RxnString();
//   TextEditingController homework = TextEditingController();
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homework {
  final String id;
  final String classLevel;
  final List<SubjectHomework> subjectHomeworks;

  Homework({
    required this.id,
    required this.classLevel,
    required this.subjectHomeworks,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      classLevel: json['classLevel'],
      subjectHomeworks: (json['subjectHomeworks'] as List)
          .map((e) => SubjectHomework.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classLevel': classLevel,
      'subjectHomeworks': subjectHomeworks.map((e) => e.toJson()).toList(),
    };
  }
}

class SubjectHomework {
  final String subject;
  final String homework;

  SubjectHomework({
    required this.subject,
    required this.homework,
  });

  factory SubjectHomework.fromJson(Map<String, dynamic> json) {
    return SubjectHomework(
      subject: json['subject'],
      homework: json['homework'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'homework': homework,
    };
  }
}

// For UI only
class SubjectHomeworkEntry {
  RxnString subject = RxnString();
  TextEditingController homework = TextEditingController();
}
