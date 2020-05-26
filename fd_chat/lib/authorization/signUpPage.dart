import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers.dart';
import '../ui/mainPage.dart';
import 'codeCheckPage.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _phoneNumberController = TextEditingController();
  final _mobileFormatter = PhoneNumberTextInputFormatter();

  String _smsVerificationCode;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Наш чат'),
      ),
      body: SingleChildScrollView(
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
                        "Введите ваш номер телефона",
                        style: TextStyle(fontSize:16.0,
                            color: Colors.blueAccent)
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      maxLength: 13,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                        _mobileFormatter,
                      ],
                      style: TextStyle(fontSize:16.0,
                          color: Colors.blueAccent),
                      controller: _phoneNumberController,
                      decoration: InputDecoration(labelText: 'Номер телефона:',  hintText: "+7"),
                    ),

                    FlatButton(key:null, onPressed: () => _verifyPhoneNumber(context),
                        color: Colors.greenAccent,
                        child:
                        Text(
                            "Получить смс с кодом",
                            style: TextStyle(fontSize:16.0,
                                color: Colors.blueAccent)
                        )
                    )
                  ]
              ),
              alignment: Alignment.center,
            ),
          )
      )
    );
  }

  /// method to verify phone number and handle phone auth
  _verifyPhoneNumber(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.toString();

    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 5),
        verificationCompleted: (authCredential) => _verificationComplete(authCredential, context),
        verificationFailed: (authException) => _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code]));
  }

  /// will get an AuthCredential object that will help with logging into Firebase.
  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {
      if (authResult.user != null) {
        saveNewUser(authResult.user);
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MainPage();
        }));
      } else {
        showToast("Ошибка авторизации");
      }
    }).catchError((error) {
      showToast(error.toString());
    });
  }

  _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeCheckPage(),
        settings: RouteSettings(
          arguments: {'verificationId': verificationId},
        ),
      ),
    );
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    showToast(authException.message.toString(), color: Colors.red);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeCheckPage(),
        settings: RouteSettings(
          arguments: {'verificationId': verificationId},
        ),
      ),
    );
  }
}