import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../screens/chatScreen.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class HomeUser extends StatefulWidget {
  final Auth auth;
  final UserData user;
  final UserData doctor;
  HomeUser({required this.auth, required this.user, required this.doctor});
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  bool isLoading = false;
  Location location = new Location();
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
                (route) => false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const List<Tab> tabs = <Tab>[
      Tab(
        icon: Icon(
          Icons.person,
          size: 35,
        ),
      ),
      Tab(
        icon: Icon(Icons.accessibility, size: 35),
      ),
      Tab(
        icon: Icon(Icons.chat, size: 35),
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 1,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.greenAccent),
              width: size.width,
              height: 60,
              child: TabBar(indicatorColor: Colors.white, tabs: tabs)),
          body: Stack(
            children: [
              TabBarView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  NetworkImage(widget.user.photoUrl!)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          widget.user.userName!,
                          style: heading1Bl,
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            (widget.user.email!).toString(),
                            style: heading2Bl,
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child:
                              button1('Logout', logoutFn, Colors.red, context),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: (widget.doctor.uid == '')
                        ? Container(
                            child: Column(
                              children: <Widget>[
                                Text('No doctor added!'),
                                TextButton(
                                  onPressed: null,
                                  child: Text('Add Doctor'),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                        NetworkImage(widget.doctor.photoUrl!)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text(
                                widget.doctor.userName!,
                                style: heading1Bl,
                              )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  (widget.doctor.email!).toString(),
                                  style: heading2Bl,
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 40),
                                child: sosButton('SOS', () async {
                                  setState(
                                    () {
                                      isLoading = true;
                                    },
                                  );
                                  await location.getLocation().then(
                                    (value) {
                                      double? latitude = value.latitude;
                                      double? longitude = value.longitude;
                                      FirebaseFirestore.instance
                                          .collection('admins')
                                          .doc(widget.doctor.uid)
                                          .collection('chats')
                                          .doc(widget.user.uid)
                                          .set(
                                        {
                                          'chats': FieldValue.arrayUnion(
                                            [
                                              {
                                                'timestamp': DateTime.now(),
                                                'latitude': latitude,
                                                'longitude': longitude,
                                                'sender': 'USER',
                                                'type': 'location',
                                              },
                                            ],
                                          ),
                                        },
                                      ).whenComplete(
                                        () {
                                          setState(
                                            () {
                                              isLoading = false;
                                            },
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                user: widget.user,
                                                otherUser: widget.doctor,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }, Colors.red, context),
                              ),
                            ],
                          ),
                  ),
                  ChatScreen(user: widget.user, otherUser: widget.doctor)
                ],
              ),
              overlayProgress(context: context, visible: isLoading),
            ],
          ),
        );
      }),
    );
  }
}
