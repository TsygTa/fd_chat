import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class Chat {
  String name;
  String lastMassege;
  DateTime messageTime;

  List<DocumentReference> users = List<DocumentReference>();

  DocumentReference reference;

  Chat(this.name, {this.lastMassege, this.messageTime, this.reference, this.users});

  factory Chat.fromSnapshot(DocumentSnapshot snapshot) {
    Chat chat = Chat.fromJson(snapshot.data);
    chat.reference = snapshot.reference;
    return chat;
  }

  factory Chat.fromJson(Map<String, dynamic> json) => _ChatFromJson(json);

  Map<String, dynamic> toJson() => _ChatToJson(this);
}

Chat _ChatFromJson(Map<String, dynamic> json) {
  return Chat(
      json['name'] as String,
      lastMassege: json['last_message'] as String,
      messageTime: json['message_time'] == null ? null : (json['message_time'] as Timestamp).toDate(),
      users: _convertUserReferences(json['users'] as List)
  );
}

List<DocumentReference> _convertUserReferences(List array) {
  if(array == null) {
    return null;
  }
  List<DocumentReference> references = List<DocumentReference>();
  array.forEach((element) {
    references.add(element);
  });
  return references;
}

Map<String, dynamic> _ChatToJson(Chat instance) => <String, dynamic> {
  'name': instance.name,
  'last_message': instance.lastMassege,
  'message_time': instance.messageTime,
  'users': instance.users
};

