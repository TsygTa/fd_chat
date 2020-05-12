import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/models/message.dart';
import 'package:fdchat/repository/dataRepository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key}) : super(key: key);
  @override
  _ChatMessagesListState createState() =>  _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {

  final DataRepository dataRepository = DataRepository();
  final dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {

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
                  height: 60,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                      color: Colors.white10, borderRadius: BorderRadius.circular(12.0)),
                  child: TextField(
                    style: TextStyle(fontSize:14.0,
                        color: Colors.blueAccent),
                    decoration: InputDecoration(labelText: '',  hintText: "Введите сообщение"),
                    onSubmitted: (String value) {
                      Message message = Message(value, isMy: true);
                      dataRepository.addMessageToChat(chatReference, message);
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

    if (message.isMy) {
      return Align(
          alignment: Alignment.centerRight,
          child:
          Container(
            padding: EdgeInsets.all(20.0),
            width: ((MediaQuery.of(context).size.width * 3)/4),
            margin: EdgeInsets.all(9.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                color: Colors.lightGreen, borderRadius: BorderRadius.circular(12.0)),
            child: Text ( message.text,  style: TextStyle(fontSize: 14)),
          )
      );

    } else {
      return Align(
          alignment: Alignment.centerLeft,
          child:
          Container(
            padding: EdgeInsets.all(20.0),
            width: ((MediaQuery.of(context).size.width * 3)/4),
            margin: EdgeInsets.all(9.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
            child: Text(message.userName + ": " + message.text,  style: TextStyle(fontSize: 14)),
          )
      );
    }
  }
}
