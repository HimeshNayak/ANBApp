import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/patientProfile.dart';
import '../services/auth.dart';
import '../services/root.dart';
import '../widgets/commonWidgets.dart';

class HomeAdmin extends StatefulWidget {
  final Auth auth;
  final UserData user;
  HomeAdmin({required this.auth, required this.user});
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
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
              widget.auth.signOut().whenComplete(() {
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
        child: bgWidget(
          context: context,
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PatientProfile()));
                      },
                      child:
                          longButton(Colors.greenAccent, 'Patient ${i + 1}')),
                );
              }),
        ),
      ),
    );
  }
}
