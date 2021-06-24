import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final bool isAdmin;
  PatientProfile(
      {required this.auth, required this.user, required this.isAdmin});

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool isLoading = false;
  bool showEditField = false;
  TextEditingController nameController = new TextEditingController();

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !showEditField,
                          child: Text(
                            widget.user.userName!,
                            style: heading1Bl,
                          ),
                        ),
                        Visibility(
                          visible: showEditField,
                          child: Container(
                            width: 200,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: widget.user.userName!,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              showEditField = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showEditField,
                    child: OutlinedButton(
                      child: Text('Save'),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (nameController.value.text.isNotEmpty) {
                          await SharedPreferences.getInstance().then((_prefs) {
                            _prefs.setString(
                                'userName', nameController.value.text);
                          });
                          await FirebaseFirestore.instance
                              .collection((widget.isAdmin) ? 'admins' : 'users')
                              .doc(widget.user.uid)
                              .update({
                            'username': nameController.value.text.toString(),
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false;
                              showEditField = false;
                            });
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RootPage(
                                      auth: widget.auth, user: widget.user),
                                ),
                                (route) => false);
                          });
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          print('Name is empty!!! Please enter your name');
                        }
                      },
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
