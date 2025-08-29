class Staff {
  final String id;
  final String name;
  final int age;
  final String qualification;
  final String contact;
  final String email;

  Staff({
    required this.id,
    required this.name,
    required this.age,
    required this.qualification,
    required this.contact,
    required this.email,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      qualification: json['qualification'],
      contact: json['contact'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'qualification': qualification,
      'contact': contact,
      'email': email,
    };
  }
}
