import 'package:flutter/material.dart';

import 'MainPage.dart';
import 'main.dart';

class CodeCheckPage extends StatefulWidget {
  CodeCheckPage({Key key}) : super(key: key);
  @override
  _CodeCheckPageState createState() => _CodeCheckPageState();
}

class _CodeCheckPageState extends State<CodeCheckPage> {
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
                        "Введите код из смс",
                        style: TextStyle(fontSize:16.0,
                            color: Colors.blueAccent)
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50, left: 50),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: TextStyle(fontSize:16.0,
                            color: Colors.blueAccent),
                        decoration: InputDecoration(labelText: 'Код',  hintText: "Введите код"),
                      ),
                    ),
                    FlatButton(key:null, onPressed:buttonPressed,
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
  void buttonPressed() {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return MainPage();
    }));
  }
}
