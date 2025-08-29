class ParentDashboard {
  final String id;
  final String name;
  final int age;
  final String studentClass;
  final String contact;

  ParentDashboard({
    required this.id,
    required this.name,
    required this.age,
    required this.studentClass,
    required this.contact,
  });

  factory ParentDashboard.fromJson(Map<String, dynamic> json) {
    return ParentDashboard(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      studentClass: json['class'],
      contact: json['contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'class': studentClass,
      'contact': contact,
    };
  }
}
