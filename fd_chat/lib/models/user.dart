import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String phone;
  String email;
  String status;
  String avatarReference;

  DocumentReference reference;

  User(this.phone, {this.name, this.email, this.status, this.avatarReference, this.reference});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User user = User.fromJson(snapshot.data);
    user.reference = snapshot.reference;
    return user;
  }

  factory User.fromJson(Map<String, dynamic> json) => _userFromJson(json);

  Map<String, dynamic> toJson() => _userToJson(this);
}

User _userFromJson(Map<String, dynamic> json) {

  return User(
      json['phone'] as String,
      name: json['name'] as String ?? "",
      email: json['email'] as String ?? "",
      status: json['status'] as String ?? "",
      avatarReference: json['avatar'] as String ?? ""
  );
}

Map<String, dynamic> _userToJson(User instance) =>
    <String, dynamic> {
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
      'avatar': instance.avatarReference
    };