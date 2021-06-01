import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileTile extends StatelessWidget {
  final UserData user;
  ProfileTile({required this.user});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(user.photoUrl.toString()),
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.userName.toString(),
                style: TextStyle(fontSize: 20),
              ),
              Text(
                user.email.toString(),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
