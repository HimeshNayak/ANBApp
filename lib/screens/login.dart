import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                TextButton(onPressed: null, child: Text('Sign In as Admin')),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: null,
                  child: Text('Sign in as a user'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
