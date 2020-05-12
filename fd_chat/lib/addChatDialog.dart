import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/repository/dataRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class AddChatDialogWidget extends StatefulWidget {
  String chatName;
  DocumentReference userReference;

  @override
  _AddChatDialogWidgetState createState() => _AddChatDialogWidgetState();
}

class _AddChatDialogWidgetState extends State<AddChatDialogWidget> {
  final DataRepository dataRepository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextField(
          autofocus: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Введите название чата"),
          onChanged: (text) => widget.chatName = text,
        ),
        Expanded (
          child: StreamBuilder<QuerySnapshot>(
            stream: dataRepository.getUsers(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();
              return _buildList(context, snapshot.data.documents);
            },
          ),
        )
      ],
      );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(5),
      child: ListBody(
          children: snapshot.map((data) => _buildListItem(context, data)).toList(),
      )
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final user = User.fromSnapshot(snapshot);
    if (user == null) {
      return Container();
    }
    return RadioListTile(
      title: Text(user.name),
      value: user.reference,
      groupValue: widget.userReference,
      onChanged: (DocumentReference value) {
        setState(() { widget.userReference = value; });
      },
    );
  }
}