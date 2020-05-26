import 'package:fdchat/repository/dataRepository.dart';
import 'package:fdchat/ui/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authorization/signUpPage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final DataRepository dataRepository = DataRepository();
String currentUserId;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Widget _defaultPage = (await _isAuthorized() ? MainPage() : SignUpPage());

  runApp(MaterialApp(
    title: 'Наш чат',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: _defaultPage,
    routes: <String, WidgetBuilder>{
      '/ui': (BuildContext context) => new MainPage(),
      '/authorization': (BuildContext context) => new SignUpPage()
    },
  ));
}

Future<bool> _isAuthorized() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentUserId = prefs.getString('USER_ID') ?? "";

  return currentUserId != "";
}