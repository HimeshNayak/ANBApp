import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../models/chatOptions.dart';
import '../widgets/messages.dart';

class ChatScreen extends StatefulWidget {
  final UserData user, otherUser;
  final String? sosMessage;
  ChatScreen({required this.user, required this.otherUser, this.sosMessage});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(widget.otherUser.photoUrl.toString()),
          ),
          SizedBox(width: 5),
          Text(widget.otherUser.userName.toString())
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: (showOptions) ? Icon(Icons.clear) : Icon(Icons.add),
        onPressed: () {
          setState(() {
            showOptions = !showOptions;
          });
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: FutureBuilder(
                  future: (widget.user.type == 'ADMIN')
                      ? FirebaseFirestore.instance
                          .collection('admins')
                          .doc(widget.user.uid)
                          .collection('chats')
                          .doc(widget.otherUser.uid)
                          .get()
                      : FirebaseFirestore.instance
                          .collection('admins')
                          .doc(widget.otherUser.uid)
                          .collection('chats')
                          .doc(widget.user.uid)
                          .get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return chats(context,
                          snapshot.data?.data() as Map<String, dynamic>);
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Visibility(
                visible: showOptions,
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  height: MediaQuery.of(context).size.height * 0.50,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(15)),
                  child: ListView.builder(
                    itemCount: chatOptions.length,
                    itemBuilder: (context, item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            if (item != chatOptions.length - 1) {
                              print('option selected : ${chatOptions[item]}');
                              if (widget.user.type == 'ADMIN') {
                                FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(widget.user.uid)
                                    .collection('chats')
                                    .doc(widget.otherUser.uid)
                                    .update({
                                  'chats': FieldValue.arrayUnion([
                                    {
                                      'timestamp': DateTime.now(),
                                      'text': chatOptions[item].toString(),
                                      'sender': 'ADMIN',
                                      'type': 'text',
                                    }
                                  ])
                                }).whenComplete(() => setState(() {
                                          showOptions = false;
                                        }));
                              } else if (widget.user.type == 'USER') {
                                FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(widget.otherUser.uid)
                                    .collection('chats')
                                    .doc(widget.user.uid)
                                    .update({
                                  'chats': FieldValue.arrayUnion([
                                    {
                                      'timestamp': DateTime.now(),
                                      'text': chatOptions[item].toString(),
                                      'sender': 'USER',
                                      'type': 'text',
                                    }
                                  ])
                                }).whenComplete(() => setState(() {
                                          showOptions = false;
                                        }));
                              }
                            } else {
                              print('Add an Option selected!');
                            }
                          },
                          child: Text(chatOptions[item]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chats(BuildContext context, Map<String, dynamic> docMap) {
    List<dynamic> chat = docMap['chats'];
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        itemCount: chat.length,
        itemBuilder: (context, item) {
          int i = chat.length - item - 1;
          if (chat[i]['type'] == 'location')
            return locationMessage(
                context, chat[i], (widget.user.type == chat[i]['sender']));
          else
            return textMessage(
                context, chat[i], (widget.user.type == chat[i]['sender']));
        },
      ),
    );
  }
}
