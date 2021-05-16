import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../widgets/messages.dart';

class ChatScreen extends StatelessWidget {
  final UserData user, otherUser;
  final String? sosMessage;
  ChatScreen({required this.user, required this.otherUser, this.sosMessage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(otherUser.photoUrl.toString()),
          ),
          SizedBox(width: 5),
          Text(otherUser.userName.toString())
        ]),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
              future: (user.type == 'ADMIN')
                  ? FirebaseFirestore.instance
                      .collection('admins')
                      .doc(user.uid)
                      .collection('chats')
                      .doc(otherUser.uid)
                      .get()
                  : FirebaseFirestore.instance
                      .collection('admins')
                      .doc(otherUser.uid)
                      .collection('chats')
                      .doc(user.uid)
                      .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return chats(
                      context, snapshot.data?.data() as Map<String, dynamic>);
                }
                return Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Widget chats(BuildContext context, Map<String, dynamic> docMap) {
    List<dynamic> chat = docMap['chats'];
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: chat.length,
        itemBuilder: (context, item) {
          int i = chat.length - item - 1;
          return locationMessage(
              context, chat[i], (user.type == chat[i]['sender']));
        },
      ),
    );
  }
}
