import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

class LoginPage extends StatefulWidget {
  final Auth auth;
  LoginPage({required this.auth});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.lightBlue,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('SWINGER LAB',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: null,
                    child: longButton(Colors.redAccent, 'Sign In as Admin')),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: null,
                  child: longButton(Colors.greenAccent, 'Sign in as a user'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
