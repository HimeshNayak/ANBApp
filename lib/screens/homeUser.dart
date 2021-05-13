import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/doctorProfile.dart';
import '../screens/chatScreen.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

class HomeUser extends StatelessWidget {
  final Auth auth;
  final User user;
  HomeUser({required this.auth, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: bgWidget(
          context: context,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                child: longButton(Colors.redAccent, 'Send SOS message'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorProfile()));
                },
                child: longButton(Colors.lightBlueAccent, 'Doctor Profile'),
              ),
              TextButton(
                onPressed: null,
                child: longButton(Colors.greenAccent, 'Open Distance Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
