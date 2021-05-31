import 'package:flutter/material.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/commonWidgets.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../services/auth.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class PatientProfile extends StatefulWidget {
  final Auth auth;
  final UserData user;
  final UserData doctor;
  PatientProfile(
      {required this.auth, required this.user, required this.doctor});

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool isLoading = false;

  logoutFn() {
    setState(
      () {
        isLoading = true;
      },
    );
    widget.auth.signOutGoogle().whenComplete(
      () {
        widget.user.getUserDetails().whenComplete(
          () {
            setState(
              () {
                isLoading = false;
              },
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RootPage(auth: widget.auth, user: widget.user),
              ),
              (route) => false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(widget.user.photoUrl!),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      widget.user.userName!,
                      style: heading1Bl,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        (widget.user.email!).toString(),
                        style: heading2Bl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: button1('Logout', logoutFn, Colors.red, context),
                  )
                ],
              ),
            ),
            overlayProgress(context: context, visible: isLoading)
          ],
        ),
      ),
    );
  }
}
