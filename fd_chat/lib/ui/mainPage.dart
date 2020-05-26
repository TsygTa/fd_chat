import 'package:fdchat/ui/chatsList.dart';
import 'package:fdchat/ui/userProfile.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              title: Text('Наш чат'),
              bottom:
              TabBar(tabs: [
                Tab(text: "Чаты",),
                Tab(text: "Профиль"),
              ],
              )
          ),
          body: TabBarView(
            children: [
              ChatsList(),
              UserProfile()
            ],
          ),
        )
    );
  }
}