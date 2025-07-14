// class UserAuthModel {
//   String id;
//   String userEmail;
//   String userName;
//   String userRole;

//   UserAuthModel(
//       {required this.id,
//       required this.userEmail,
//       required this.userName,
//       required this.userRole});
//   factory UserAuthModel.fromJson(Map<String, dynamic> json) {
//     return UserAuthModel(
//         id: json['_id'] ?? '',
//         userEmail: json['userEmail'] ?? '',
//         userName: json['userName'] ?? '',
//         userRole: json['userRole'] ?? '');
//   }

//   Map<String, dynamic> toJson() {
//     return {'userEmail': userEmail, 'userName': userName, 'userRole': userRole};
//   }

//   Map<String, dynamic> toMap() => {
//         'id': id,
//         'userEmail': userEmail,
//         'userName': userName,
//         'userRole': userRole
//       };

//   factory UserAuthModel.fromMap(Map<String, dynamic> map) => UserAuthModel(
//       id: map['id'],
//       userEmail: map['userEmail'],
//       userName: map['userName'],
//       userRole: map['userRole']);
// }
