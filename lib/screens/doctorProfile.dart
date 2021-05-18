import 'package:flutter/material.dart';

import '../models/user.dart';

class DoctorProfile extends StatelessWidget {
  final UserData doctor;
  DoctorProfile({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(doctor.photoUrl.toString()),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  doctor.userName.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
