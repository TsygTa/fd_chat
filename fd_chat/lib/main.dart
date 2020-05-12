import 'package:fdchat/chatMessagesList.dart';
import 'package:fdchat/chatsList.dart';
import 'package:fdchat/userProfile.dart';
import 'package:flutter/material.dart';

import 'mainPage.dart';
import 'authorization/signUpPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Наш чат',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

