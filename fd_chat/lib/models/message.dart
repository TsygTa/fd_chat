import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/user.dart';

class Message {
  String text;
  DateTime time;
  String userId;

  User user;

  DocumentReference reference;

  Message(this.text, {this.time, this.userId, this.reference});

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Message message = Message.fromJson(snapshot.data);
    message.reference = snapshot.reference;
    return message;
  }
  factory Message.fromJson(Map<String, dynamic> json) => _messageFromJson(json);
  Map<String, dynamic> toJson() => _messageToJson(this);
}

Message _messageFromJson(Map<String, dynamic> json) {
  return Message(
    json['text'] as String,
    time: json['time'] == null ? null : (json['time'] as Timestamp).toDate(),
    userId: json['user_id'] as String
  );
}

Map<String, dynamic> _messageToJson(Message instance) => <String, dynamic> {
  'text': instance.text,
  'time': instance.time,
  'user_id': instance.userId
};
