import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  DateTime time;
  String userName;
  bool isMy;

  DocumentReference reference;

  Message(this.text, {this.time, this.userName, this.isMy, this.reference});

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    Message message = Message.fromJson(snapshot.data);
    message.reference = snapshot.reference;
    return message;
  }
  factory Message.fromJson(Map<String, dynamic> json) => _MessageFromJson(json);
  Map<String, dynamic> toJson() => _MessageToJson(this);
}

Message _MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['text'] as String,
    time: json['time'] == null ? null : (json['time'] as Timestamp).toDate(),
    userName: json['user_name'] as String,
    isMy: json['is_my'] as bool
  );
}

Map<String, dynamic> _MessageToJson(Message instance) => <String, dynamic> {
  'text': instance.text,
  'time': instance.time,
  'user_name': instance.userName,
  'is_my': instance.isMy
};
