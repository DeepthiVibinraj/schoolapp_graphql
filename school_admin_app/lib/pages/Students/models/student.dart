class Student {
  final String id;
  final String name;
  final int age;
  final String studentClass;
  final String contact;
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.studentClass,
    required this.contact,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      studentClass: json['class'],
      contact: json['contact'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'class': studentClass,
      'contact': contact,
      'email': email,
    };
  }
}
