import 'package:flutter/material.dart';

class ChatMessagesList extends StatefulWidget {
  ChatMessagesList({Key key}) : super(key: key);
  @override
  _ChatMessagesListState createState() =>  _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  @override
  Widget build(BuildContext context) {
    final String chatName = ModalRoute.of(context).settings.arguments;
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
                child: ListView(
                  children: _getListData(),
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
                  )
              )
          ]
      ),

    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 10; i++) {
      if (i % 2 == 0 ) {
        widgets.add( Align(
            alignment: Alignment.centerRight,
            child:
            Container(
              padding: EdgeInsets.all(20.0),
              width: ((MediaQuery.of(context).size.width * 3)/4),
              margin: EdgeInsets.all(9.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                  color: Colors.lightGreen, borderRadius: BorderRadius.circular(12.0)),
              child: Text ("Сообщение $i",  style: TextStyle(fontSize: 14)),
            )
        ),
        );
      } else {
        widgets.add( Align(
            alignment: Alignment.centerLeft,
            child:
            Container(
              padding: EdgeInsets.all(20.0),
              width: ((MediaQuery.of(context).size.width * 3)/4),
              margin: EdgeInsets.all(9.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                  color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
              child: Text ("Сообщение $i",  style: TextStyle(fontSize: 14)),
            )
        ),
        );
      }
    }
    return widgets;
  }
}
