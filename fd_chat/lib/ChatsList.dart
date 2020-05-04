import 'package:fdchat/ChatMessagesList.dart';
import 'package:flutter/material.dart';

class ChatsList extends StatefulWidget {
  ChatsList({Key key}) : super(key: key);
  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       ListView(
         padding: EdgeInsets.all(9),
         children: _getListData(),
      ),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 10; i++) {
      widgets.add(GestureDetector(
        child: Container(
          padding: EdgeInsets.all(9),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.insert_emoticon, size: 36,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Название чата $i',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 16),),
                    Text ("Последнее сообщение чата $i",  style: TextStyle(fontSize: 14))
                  ],),
                Text("Дата/Время", style: TextStyle(fontSize: 10))
              ]
          ),
        ),
        onTap: () {
//          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
//            return ChatMessagesList();
//          }));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatMessagesList(),
              settings: RouteSettings(
                arguments: "Название чата $i",
              ),
            ),
          );
        },
      ));
    }
    return widgets;
  }
}