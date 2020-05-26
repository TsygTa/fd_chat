import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/chat.dart';
import 'package:fdchat/models/message.dart';
import 'package:fdchat/models/user.dart';

import '../main.dart';

class DataRepository {
  final CollectionReference chatsCollection = Firestore.instance.collection('chats');
  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Stream<QuerySnapshot> getChats() {
    return chatsCollection.snapshots();
  }

  void updateChat(Chat chat) {
    chatsCollection.document(chat.reference.documentID).updateData(chat.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return usersCollection.snapshots();
  }

  DocumentReference getUser(String id) {
    return usersCollection.document(id);
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

  void addUser(String uid, User user) {
    DocumentReference reference = usersCollection.document(uid);
    reference.setData(user.toJson());
  }

  void updateUser(User user) {
    usersCollection.document(user.reference.documentID).updateData(user.toJson());
  }
}