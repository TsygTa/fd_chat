import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/chat.dart';
import 'package:fdchat/models/message.dart';

class DataRepository {
  final CollectionReference chatsCollection = Firestore.instance.collection('chats');
  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Stream<QuerySnapshot> getChats() {
    return chatsCollection.snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return usersCollection.snapshots();
  }

  Stream<QuerySnapshot> getMessages(DocumentReference chatReference) {
    return chatsCollection.document(chatReference.documentID)
        .collection('messages').snapshots();
  }

  Future<DocumentReference> addChat(Chat chat) {
    return chatsCollection.add(chat.toJson());
  }

  void addMessageToChat(DocumentReference chatReference,
      Message message) {
    chatsCollection.document(chatReference.documentID)
        .collection('messages').reference().add(message.toJson());
  }
}