import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/doctorProfile.dart';
import '../screens/chatScreen.dart';
import '../services/auth.dart';
import '../services/root.dart';
import '../widgets/commonWidgets.dart';

class HomeUser extends StatefulWidget {
  final Auth auth;
  final UserData user;
  HomeUser({required this.auth, required this.user});
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              widget.auth.signOutGoogle().whenComplete(() {
                widget.user.getUserDetails().whenComplete(() {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RootPage(auth: widget.auth, user: widget.user)),
                      (route) => false);
                });
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            bgWidget(
              context: context,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen()));
                    },
                    child: longButton(Colors.redAccent, 'Send SOS message'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorProfile()));
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
            overlayProgress(context: context, visible: isLoading),
          ],
        ),
      ),
    );
  }
}
