import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../screens/patientProfile.dart';
import '../screens/chatScreen.dart';
import '../services/auth.dart';
import '../style/fonts.dart';
import '../widgets/commonWidgets.dart';
import '../widgets/profileTile.dart';
import '../widgets/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

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
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout, color: Colors.white),
      //       onPressed: () {
      //         setState(
      //           () {
      //             isLoading = true;
      //           },
      //         );
      //         widget.auth.signOut().whenComplete(
      //           () {
      //             widget.user.getUserDetails().whenComplete(
      //               () {
      //                 setState(
      //                   () {
      //                     isLoading = false;
      //                   },
      //                 );
      //                 Navigator.pushAndRemoveUntil(
      //                     context,
      //                     MaterialPageRoute(
      //                       builder: (context) =>
      //                           RootPage(auth: widget.auth, user: widget.user),
      //                     ),
      //                     (route) => false);
      //               },
      //             );
      //           },
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            bgWidget(
              context: context,
              child: Column(
                children: [
                  //     ProfileTile(
                  //       user: widget.user,
                  //       function: () {},
                  //     ),
                  //     Align(
                  //       alignment: Alignment.topLeft,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               'Your Patients',
                  //               style: TextStyle(fontSize: 15),
                  //             ),
                  //             OutlinedButton(
                  //               onPressed: null,
                  //               child: Text('View Requests'),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text('Patients', style: heading1Bl),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 2,
                    child: Container(color: Colors.blueGrey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('admins')
                        .doc(widget.user.uid)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> doctorMap =
                            snapshot.data?.data() as Map<String, dynamic>;
                        List<dynamic> patientsUidList = doctorMap['patients'];
                        return patientsList(patientsUidList);
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientProfile(
                          auth: widget.auth,
                          user: widget.user,
                          isAdmin: true,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      widget.user.photoUrl.toString(),
                    ),
                  )),
            ),
            overlayProgress(context: context, visible: isLoading),
          ],
        ),
      ),
    );
  }

  Widget patientsList(List<dynamic> list) {
    if (list.length != 0)
      return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, item) {
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(list[item])
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
              if (snap.hasData) {
                Map<String, dynamic> userMap =
                    snap.data?.data() as Map<String, dynamic>;
                UserData userData = new UserData.setFields(userMap);
                return Column(
                  children: [
                    ProfileTile(
                      user: userData,
                    ),
                    button1('View Chats', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            user: widget.user,
                            otherUser: userData,
                          ),
                        ),
                      );
                    }, Colors.greenAccent, context),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    else
      return Container(
        child: Text(
          'No Patient Added!',
          style: heading2Bl,
        ),
      );
  }
}
