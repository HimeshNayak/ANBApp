import 'package:flutter/material.dart';

import '../models/user.dart';

class EditProfile extends StatefulWidget {
  final UserData user;
  EditProfile({required this.user});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: widget.user.userName),
          ),
          SizedBox(
            height: 30,
          ),
          OutlinedButton(
            child: Text('Submit'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
