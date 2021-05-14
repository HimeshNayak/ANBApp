import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileTile extends StatelessWidget {
  final UserData user;
  final Function function;
  ProfileTile({required this.user, required this.function});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
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
              Text(user.userName.toString(), style: TextStyle(fontSize: 20)),
              Text(user.email.toString(), style: TextStyle(fontSize: 12)),
              OutlinedButton(
                onPressed: () {
                  function();
                },
                child: Text('View Complete Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
