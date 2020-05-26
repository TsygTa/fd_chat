import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/user.dart';
import 'package:fdchat/ui/chatMessagesList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addChatDialog.dart';
import '../main.dart';
import '../models/chat.dart';

class ChatsList extends StatefulWidget {
  ChatsList({Key key}) : super(key: key);
  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {

  final dateFormat = DateFormat('hh:mm dd-MM-yyyy');
  User user;

  Future<dynamic> _getUserProfile() async {
    final DocumentReference document = dataRepository.getUser(currentUserId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        user = User.fromSnapshot(snapshot);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dataRepository.getChats(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addChat();
        },
        tooltip: 'Добавить чат',
        child: Icon(Icons.add),
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

    final chat = Chat.fromSnapshot(snapshot);
    if(chat == null) {
      return Container();
    }
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(9),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(chat.name,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 16),),
                    Text (chat.lastMassege == null ? "" : chat.lastMassege,
                        style: TextStyle(fontSize: 14))
                  ],),
                Text(chat.messageTime == null ? "" : dateFormat.format(chat.messageTime), style: TextStyle(fontSize: 10))
              ]
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatMessagesList(),
              settings: RouteSettings(
                arguments: {'title': chat.name, 'chatReference': chat.reference},
              ),
            ),
          );
        },
      );
  }

  void _addChat() {
    AddChatDialogWidget dialogWidget = AddChatDialogWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Добавление чата"),
              content: dialogWidget,
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      List<DocumentReference> users = List<DocumentReference>();
                      users.add(dialogWidget.userReference);
                      users.add(user.reference);
                      Chat chat = Chat(dialogWidget.chatName, users: users);
                      dataRepository.addChat(chat);
                      Navigator.of(context).pop();
                    },
                    child: Text("Add")),
              ]);
        });
  }
}