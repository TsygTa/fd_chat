import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/helpers.dart';
import 'package:fdchat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../main.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);
  @override
  _UserProfileState createState() =>  _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final nameTextFieldController = TextEditingController();
  final emailTextFieldController = TextEditingController();
  final statusTextFieldController = TextEditingController();

  Stream<DocumentSnapshot> _stream;

  User user;
  bool  _isSaveButtonDisabled;
  File _image;

  _pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  Future<dynamic> _getData() async {
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
    _isSaveButtonDisabled = true;
    _getData();
  }

  _setDisabled(bool value) {
    setState(() {
      _isSaveButtonDisabled = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameTextFieldController.dispose();
    emailTextFieldController.dispose();
    statusTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(9.0),
        child: _buildProfile(context)
      )
    );
}
  Widget _buildProfile(BuildContext context) {

    if(user == null) {
      return Container();
    }
    nameTextFieldController.text = user.name;
    emailTextFieldController.text = user.email;
    statusTextFieldController.text = user.status;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                width: 90,
                height: 90,
                child: _image != null ? Image.file(_image)
                    : Icon(Icons.portrait, size: 90,),
              ),
              FlatButton(key: null,
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  child: Text("Правка",
                      style: TextStyle(fontSize:16.0, color: Colors.blueAccent)
                  )
              ),
            ],
          ),
          Container (
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: nameTextFieldController,
                style: TextStyle(fontSize:14.0),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'ИМЯ:',  hintText: "Введите имя"),
                onSubmitted: (String value) {
                  setState(() {
                    user.name = value;
                    _setDisabled(false);
                  });
                },
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
              )
          ),

          Container (
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            height: 50,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                color: Colors.white10),
            child: Text("НОМЕР ТЕЛЕФОНА: ${user.phone}", style: TextStyle(fontSize: 14)),
          ),

          Container (
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailTextFieldController,
                style: TextStyle(fontSize:14.0),
                decoration: InputDecoration(labelText: 'Email:',  hintText: "Введите email"),
                onSubmitted: (String value) {
                  setState(() {
                    user.email = value;
                    _setDisabled(false);
                  });
                },
                textInputAction: TextInputAction.done,
              )
          ),
          Container (
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: statusTextFieldController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize:14.0),
                decoration: InputDecoration(labelText: 'СТАТУС:',  hintText: "Введите статус"),
                textInputAction: TextInputAction.done,
                onSubmitted: (String value) {
                  setState(() {
                    user.status = value;
                    _setDisabled(false);
                  });
                },
                textCapitalization: TextCapitalization.sentences,
              )
          ),
          FlatButton(key:null,
              onPressed: _isSaveButtonDisabled ? null : _onSavePressed,
              child: Text("Сохранить",
                  style: TextStyle(fontSize:16.0, color: Colors.blueAccent)
              )
          ),
        ]
    );
  }

  _onSavePressed() {
    if (user != null) {
      user.status = statusTextFieldController.text;
      user.name = nameTextFieldController.text;
      user.email = emailTextFieldController.text;
      dataRepository.updateUser(user);
      showToast("Профиль сохранен");
    }
  }
}