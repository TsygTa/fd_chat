import 'package:fdchat/ChatMessagesList.dart';
import 'package:fdchat/ChatsList.dart';
import 'package:fdchat/UserProfile.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'SignUpPage.dart';

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

