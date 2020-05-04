import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CodeCheckPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
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
                        decoration: InputDecoration(labelText: 'Номер телефона:',  hintText: "+7"),
                      ),

                      FlatButton(key:null, onPressed:buttonPressed,
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
      ),

    );
  }
  void buttonPressed(){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return CodeCheckPage();
    }));
  }
}

final _mobileFormatter = NumberTextInputFormatter();

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('+');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 2) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 1) + ' ');
      if (newValue.selection.end >= 1) selectionIndex += 1;
    }

    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}