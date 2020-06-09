import 'dart:async';

import 'package:fdchat/repository/dataRepository.dart';
import 'package:fdchat/ui/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/animation.dart';

import 'authorization/signUpPage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final DataRepository dataRepository = DataRepository();
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
String currentUserId;

Widget _defaultPage;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  _defaultPage = (await _isAuthorized() ? MainPage() : SignUpPage());

  runApp(LogoApp());
}
//void main() async {
//
//  WidgetsFlutterBinding.ensureInitialized();
//
//  Widget _defaultPage = (await _isAuthorized() ? MainPage() : SignUpPage());
//
//  runApp(MaterialApp(
//    title: 'Наш чат',
//    theme: ThemeData(
//      primarySwatch: Colors.blue,
//    ),
//    home: _defaultPage,
//    routes: <String, WidgetBuilder>{
//      '/ui': (BuildContext context) => new MainPage(),
//      '/authorization': (BuildContext context) => new SignUpPage()
//    },
//  ));
//}

Future<bool> _isAuthorized() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentUserId = prefs.getString('USER_ID') ?? "";

  return currentUserId != "";
}

class LogoApp extends StatefulWidget{
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    int counter = 0;
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)//;
//      ..addListener(() {
//      setState(() {
//
//      });
//    });
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed) {
          if (counter >= 1) {
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
          counter++;
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })..addStatusListener((state) => print('$state'));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
//  Widget build(BuildContext context) => AnimatedLogo(animation: animation);
//  Widget build(BuildContext context) {
//    return Center(
//      child: Container(
//        margin: EdgeInsets.symmetric(vertical: 10),
//        height: animation.value,
//        width: animation.value,
//        child: FlutterLogo(),
//      ),
//    );
//  }
//}

  Widget build(BuildContext context) {
    return GrowTransition(
        child: LogoWidget(),
        animation: animation
    );
  }
}

//class AnimatedLogo extends AnimatedWidget {
//  AnimatedLogo({Key key, Animation<double> animation})
//      : super(key: key, listenable: animation);
//
//  Widget build(BuildContext context) {
//    final animation = listenable as Animation<double>;
//    return Center(
//      child: Container(
//        margin: EdgeInsets.symmetric(vertical: 10),
//        height: animation.value,
//        width: animation.value,
//        child: FlutterLogo(),
//      ),
//    );
//  }
//}

class LogoWidget extends StatelessWidget {
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: FlutterLogo(),
  );
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Center(
    child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          height: animation.value,
          width: animation.value,
          child: child,
        ),
        child: child
    ),
  );
}
