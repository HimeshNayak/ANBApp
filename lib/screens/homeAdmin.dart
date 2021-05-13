import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/patientProfile.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

class HomeAdmin extends StatelessWidget {
  final Auth auth;
  final User user;
  HomeAdmin({required this.auth, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                })),
      ),
    );
  }
}
