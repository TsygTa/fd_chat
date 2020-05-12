import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;

  DocumentReference reference;

  User(this.name, {this.reference});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    User user = User.fromJson(snapshot.data);
    user.reference = snapshot.reference;
    return user;
  }

  factory User.fromJson(Map<String, dynamic> json) => _UserFromJson(json);

  Map<String, dynamic> toJson() => _UserToJson(this);
}

User _UserFromJson(Map<String, dynamic> json) {

  return User(json['name'] as String);
}

Map<String, dynamic> _UserToJson(User instance) =>
    <String, dynamic> {
      'name': instance.name
    };