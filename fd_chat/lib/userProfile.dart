import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);
  @override
  _UserProfileState createState() =>  _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:
       SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(9.0),
        child:
         Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(9.0),
                child: Icon(
                    Icons.insert_emoticon,
                    size: 48.0)
              ),
              FlatButton(key:null,
                  //onPressed:buttonPressed,
                  child:
                  Text("Правка",
                      style: TextStyle(fontSize:14.0,
                          color: Colors.blueAccent)
                  )
              ),

              Container (
                  padding: EdgeInsets.all(9.0),
                  margin: EdgeInsets.all(15.0),
                  alignment: Alignment.centerLeft,
//                  decoration: BoxDecoration(border: Border.all(color: Colors.grey),
//                      color: Colors.white10),
                  child: TextField(
                    style: TextStyle(fontSize:14.0),
                    decoration: InputDecoration(labelText: 'ИМЯ:',  hintText: "Введите имя"),
                  )
              ),

              Container (
                padding: EdgeInsets.all(9.0),
                margin: EdgeInsets.all(20.0),
                height: 50,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                    color: Colors.white10),
                child: Text("НОМЕР ТЕЛЕФОНА: +7 000 000-00-00", style: TextStyle(fontSize: 14)),
              ),

              Container (
                  padding: EdgeInsets.all(9.0),
                  margin: EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
//                  decoration: BoxDecoration(border: Border.all(color: Colors.grey),
//                      color: Colors.white10),
                  child: TextField(
                    style: TextStyle(fontSize:14.0),
                    decoration: InputDecoration(labelText: 'СТАТУС:',  hintText: "Введите статус"),
                  )
              ),
            ]

        ),

      ),

    );
  }
}