import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fdchat/helpers.dart';
import 'package:fdchat/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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
  File _imageFile;
  Uint8List _imageContent;

  _pickImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _imageFile = image;
      writeImageToLocal(_imageFile.readAsBytesSync());
    });
  }

  Future<dynamic> _getData() async {
    final DocumentReference document = dataRepository.getUser(currentUserId);

    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        user = User.fromSnapshot(snapshot);
      });
    });

    await readImageFromLocal().then((value) async{
      setState(() {
        _imageContent = value;
      });
    });

    if(_imageContent == null || _imageContent.length == 0) {
      await _downloadImage(user.avatarReference).then((value) {
        if(value != null) {
          writeImageToLocal(value);
        }
        _imageContent = value;
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _userProfileImageFile async {
    final path = await _localPath;
    return File('$path/user_profile_image');
  }

  Future<Uint8List> readImageFromLocal() async {
    try {
      final file = await _userProfileImageFile;
      Uint8List contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      print('$e');
      return null;
    }
  }

  Future<File> writeImageToLocal(Uint8List content) async {
    final file = await _userProfileImageFile;
    return file.writeAsBytes(content);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _isSaveButtonDisabled = true;
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
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                    color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(user.avatarReference),
                ),
              ),
//              CircleAvatar(
//                radius: 45,
//                child: AspectRatio(
//                  aspectRatio: 1/2,
//                  child: _imageFile != null ? Image.file(_imageFile)
//                      : (_imageContent != null && _imageContent.length > 0 ?
//                  Image.memory(_imageContent)
//                      : Icon(Icons.portrait, size: 90)),
//                ),
//              ),
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
              onPressed: _onSavePressed,//_isSaveButtonDisabled ? null : _onSavePressed,
              child: Text("Сохранить",
                  style: TextStyle(fontSize:16.0, color: Colors.blueAccent)
              )
          ),
        ]
    );
  }

  _onSavePressed() async{
    if(_imageFile != null) {
      await _uploadImage().then((value) {
        _saveUser(value);
      });
    } else {
      _saveUser(null);
    }
  }

  _saveUser(String avatar) {
    if (user != null) {
      user.status = statusTextFieldController.text;
      user.name = nameTextFieldController.text;
      user.email = emailTextFieldController.text;
      user.avatarReference = avatar;
      dataRepository.updateUser(user);
      showToast("Профиль сохранен");
    }
  }

  Future<String> _uploadImage() async {

    String fileName = user.reference.documentID;
    StorageReference reference = firebaseStorage.ref().child("usersimages/avatars/$fileName");

    StorageUploadTask uploadTask = reference.putFile(_imageFile);

    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String location = await storageTaskSnapshot.ref.getDownloadURL();

    return location;
  }

  Future<Uint8List> _downloadImage(String url) async {
    if(url != null) {
      final http.Response downloadData = await http.get(url);
      final Uint8List fileContents = downloadData.bodyBytes;
      return fileContents;
    }
    return null;
  }
}