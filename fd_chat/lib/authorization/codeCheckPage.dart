import 'package:fdchat/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers.dart';
import '../ui/mainPage.dart';
import '../main.dart';

class CodeCheckPage extends StatefulWidget {
  CodeCheckPage({Key key}) : super(key: key);
  @override
  _CodeCheckPageState createState() => _CodeCheckPageState();
}

class _CodeCheckPageState extends State<CodeCheckPage> {

  TextEditingController _smsCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    _smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Map _argumets = ModalRoute.of(context).settings.arguments as Map;
    final String _verificationId = _argumets['verificationId'];
    final FirebaseAuth _auth = FirebaseAuth.instance;

    void _onButtonPressed() async {
      AuthCredential _authCredential = PhoneAuthProvider.getCredential(
          verificationId: _verificationId, smsCode: _smsCodeController.text);

      _auth.signInWithCredential(_authCredential).then((AuthResult value) {
        if (value.user != null) {
          saveNewUser(value.user);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainPage()));
        } else {
          showToast("Введенный код неверный, попробуйте еще раз.");
        }
      }).catchError((error) {
        showToast("Ошибка авторизации", color: Colors.red);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Наш чат'),
      ),
      body:
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 400,
              child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        "Регистрация",
                        style: TextStyle(fontSize:24.0,
                            color: Colors.blueAccent)
                    ),
                    Text(
                        "Введите код из смс",
                        style: TextStyle(fontSize:16.0,
                            color: Colors.blueAccent)
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50, left: 50),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _smsCodeController,
                        maxLength: 6,
                        style: TextStyle(fontSize:16.0,
                            color: Colors.blueAccent),
                        decoration: InputDecoration(labelText: 'Код',  hintText: "Введите код"),
                      ),
                    ),
                    FlatButton(key:null, onPressed: _onButtonPressed,
                        color: Colors.greenAccent,
                        child:
                        Text(
                            "Проверить код",
                            style: TextStyle(fontSize:16.0,
                                color: Colors.blueAccent)
                        )
                    )
                  ]

              ),
              alignment: Alignment.center,
            ),
          )
      ),
    );
  }
}

void saveNewUser(FirebaseUser user) async {
  User newUser = User(user.phoneNumber);
  dataRepository.addUser(user.uid, newUser);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('USER_ID', user.uid);
}