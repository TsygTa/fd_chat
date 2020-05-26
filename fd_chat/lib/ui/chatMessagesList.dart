import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/chat.dart';
import 'package:fdchat/models/message.dart';
import 'package:fdchat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key}) : super(key: key);
  @override
  _ChatMessagesListState createState() =>  _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {

  final dateFormat = DateFormat('hh:mm dd-MM-yyyy');
  final messageTextFieldController = TextEditingController();
  User user;

  Future<dynamic> _getUserProfile() async {
    final DocumentReference document = dataRepository.getUser(currentUserId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        user = User.fromSnapshot(snapshot);
      });
    });
  }

  _clearTextInput() {
    messageTextFieldController.clear();
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }
  @override
  Widget build(BuildContext context) {
    final Map argumets = ModalRoute.of(context).settings.arguments as Map;
    final String chatName = argumets['title'];
    final DocumentReference chatReference = argumets['chatReference'] as DocumentReference;

    return  Scaffold(
      appBar:  AppBar(
        title:  Text(chatName),
      ),
      body:
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: dataRepository.getMessages(chatReference),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return LinearProgressIndicator();
                    return _buildList(context, snapshot.data.documents);
                  },
                )
            ),
            Container (
                  padding: EdgeInsets.all(9.0),
                  margin: EdgeInsets.all(20.0),
             //     height: 60,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                      color: Colors.white10, borderRadius: BorderRadius.circular(12.0)),
                  child: TextField(
                    style: TextStyle(fontSize:14.0,
                        color: Colors.blueAccent),
                    decoration: InputDecoration(labelText: '',  hintText: "Введите сообщение"),
                    textInputAction: TextInputAction.send,
                    maxLines: 1,
                    controller: messageTextFieldController,
                    onSubmitted: (String value) {
                      DateTime now = DateTime.now();
                      Message message = Message(value, userId: currentUserId, time: now, userName: user.name);
                      dataRepository.addMessageToChat(chatReference, message);
                      Chat chat = Chat(chatName, messageTime: now, lastMassege: value, reference: chatReference);
                      dataRepository.updateChat(chat);
                      _clearTextInput();
                    }
                  )
              )
          ]
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.all(9),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {

    final message = Message.fromSnapshot(snapshot);
    if(message == null) {
      return Container();
    }

    if (message.userId == currentUserId) {
      return Align(
          alignment: Alignment.centerRight,
          child:
          Container(
            padding: EdgeInsets.all(9.0),
            width: ((MediaQuery.of(context).size.width * 3)/4),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                color: Colors.lightGreen, borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(message.time == null ? ""
                      : dateFormat.format(message.time), style: TextStyle(fontSize: 10)),
                ),
                Text (message.text,  style: TextStyle(fontSize: 16)),
              ]
            ),
          )
      );

    } else {
      return Align(
          alignment: Alignment.centerLeft,
          child:
          Container(
            padding: EdgeInsets.all(9.0),
            width: ((MediaQuery.of(context).size.width * 3)/4),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(message.userName + ": ",  style: TextStyle(fontSize: 10)),
                    Text(message.time == null ? ""
                        : dateFormat.format(message.time), style: TextStyle(fontSize: 10)),
            ]
                ),
                Text(message.text,  style: TextStyle(fontSize: 16)),
              ]
          ),
          )
      );
    }
  }
}
