import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
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
  TextEditingController messageController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                widget.otherUser.photoUrl.toString(),
              ),
            ),
            SizedBox(width: 5),
            Text(
              widget.otherUser.userName.toString(),
            ),
          ],
        ),
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
                    return chats(
                        context, snapshot.data?.data() as Map<String, dynamic>);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 130,
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter Text',
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 20,
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (messageController.text.isNotEmpty) {
                          if (widget.user.type == 'ADMIN') {
                            FirebaseFirestore.instance
                                .collection('admins')
                                .doc(widget.user.uid)
                                .collection('chats')
                                .doc(widget.otherUser.uid)
                                .update(
                              {
                                'chats': FieldValue.arrayUnion(
                                  [
                                    {
                                      'timestamp': DateTime.now(),
                                      'text': messageController.text.toString(),
                                      'sender': 'ADMIN',
                                      'type': 'text',
                                    },
                                  ],
                                )
                              },
                            ).whenComplete(
                              () => setState(
                                () {
                                  showOptions = false;
                                  messageController.clear();
                                },
                              ),
                            );
                          } else if (widget.user.type == 'USER') {
                            FirebaseFirestore.instance
                                .collection('admins')
                                .doc(widget.otherUser.uid)
                                .collection('chats')
                                .doc(widget.user.uid)
                                .update(
                              {
                                'chats': FieldValue.arrayUnion(
                                  [
                                    {
                                      'timestamp': DateTime.now(),
                                      'text': messageController.text.toString(),
                                      'sender': 'USER',
                                      'type': 'text',
                                    },
                                  ],
                                )
                              },
                            ).whenComplete(
                              () => setState(
                                () {
                                  showOptions = false;
                                  messageController.clear();
                                },
                              ),
                            );
                          }
                        } else {
                          print('it is empty');
                        }
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: (showOptions)
                            ? Icon(
                                Icons.clear,
                                size: 20,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          setState(
                            () {
                              showOptions = !showOptions;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 10,
              right: 10,
              child: Visibility(
                visible: showOptions,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.30,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: FutureBuilder(
                    future: (widget.user.type == 'USER')
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.user.uid)
                            .get()
                        : FirebaseFirestore.instance
                            .collection('admins')
                            .doc(widget.user.uid)
                            .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<dynamic, dynamic> map =
                            snapshot.data?.data() as Map<dynamic, dynamic>;
                        List<dynamic> chatOptions = map['chatOptions'];
                        chatOptions.add('Add Option');
                        return addOptionsWidget(context, chatOptions);
                      }
                      return Center(
                        child: CircularProgressIndicator(),
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
              context,
              chat[i],
              (widget.user.type == chat[i]['sender']),
            );
          else
            return textMessage(
              context,
              chat[i],
              (widget.user.type == chat[i]['sender']),
            );
        },
      ),
    );
  }

  Widget addOptionsWidget(BuildContext context, List<dynamic> chatOptions) {
    return ListView.builder(
      itemCount: chatOptions.length,
      itemBuilder: (context, item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              if (item != chatOptions.length - 1) {
                print('option selected : ${chatOptions[item]}');
                if (widget.user.type == 'ADMIN') {
                  FirebaseFirestore.instance
                      .collection('admins')
                      .doc(widget.user.uid)
                      .collection('chats')
                      .doc(widget.otherUser.uid)
                      .update(
                    {
                      'chats': FieldValue.arrayUnion(
                        [
                          {
                            'timestamp': DateTime.now(),
                            'text': chatOptions[item].toString(),
                            'sender': 'ADMIN',
                            'type': 'text',
                          },
                        ],
                      ),
                    },
                  ).whenComplete(
                    () => setState(
                      () {
                        showOptions = false;
                      },
                    ),
                  );
                } else if (widget.user.type == 'USER') {
                  FirebaseFirestore.instance
                      .collection('admins')
                      .doc(widget.otherUser.uid)
                      .collection('chats')
                      .doc(widget.user.uid)
                      .update(
                    {
                      'chats': FieldValue.arrayUnion(
                        [
                          {
                            'timestamp': DateTime.now(),
                            'text': chatOptions[item].toString(),
                            'sender': 'USER',
                            'type': 'text',
                          },
                        ],
                      ),
                    },
                  ).whenComplete(
                    () => setState(
                      () {
                        showOptions = false;
                      },
                    ),
                  );
                }
              } else {
                _showAddOptionDialog(context);
              }
            },
            child: Text(chatOptions[item]),
          ),
        );
      },
    );
  }

  Future<void> _showAddOptionDialog(context) async {
    TextEditingController addController = new TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter text and app it to your list!'),
                TextField(
                  controller: addController,
                  decoration: InputDecoration(
                    hintText: 'Enter Message',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ADD'),
              onPressed: () {
                if (addController.text.isNotEmpty) {
                  Map<String, dynamic> map = {
                    'chatOptions': FieldValue.arrayUnion(
                      [addController.text.toString()],
                    ),
                  };
                  if (widget.user.type == 'USER') {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.user.uid)
                        .update(map)
                        .whenComplete(() => Navigator.pop(context));
                  } else {
                    FirebaseFirestore.instance
                        .collection('admins')
                        .doc(widget.user.uid)
                        .update(map)
                        .whenComplete(() => Navigator.pop(context));
                  }
                }
              },
            ),
            TextButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
