import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../screens/doctorProfile.dart';
import '../screens/chatScreen.dart';
import '../screens/distanceScreen.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';
import '../widgets/profileTile.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class HomeUser extends StatefulWidget {
  final Auth auth;
  final UserData user;
  HomeUser({required this.auth, required this.user});
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
      // onPageChanged: (int page) {
      //   setState(() {
      //     pageIndex = page;
      //     print("the page index is $pageIndex");
      //   });
      // },
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
          body: TabBarView(
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
                          backgroundImage: NetworkImage(widget.user.photoUrl!)),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: button1('Logout', logoutFn, Colors.red, context),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.user.uid)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> userMap =
                              snapshot.data?.data() as Map<String, dynamic>;
                          String doctorUid = userMap['doctorUid'] ?? '';
                          if (doctorUid.isNotEmpty)
                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('admins')
                                  .doc(doctorUid)
                                  .get(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snap) {
                                if (snap.hasData) {
                                  Map<String, dynamic> doctorMap =
                                      snap.data?.data() as Map<String, dynamic>;
                                  UserData doctorData =
                                      new UserData.setFields(doctorMap);
                                  return Column(
                                    children: [
                                      Center(
                                        child: CircleAvatar(
                                            radius: 70,
                                            backgroundImage: NetworkImage(
                                                doctorData.photoUrl!)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                          child: Text(
                                        doctorData.userName!,
                                        style: heading1Bl,
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          (doctorData.email!).toString(),
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
                                              double? longitude =
                                                  value.longitude;
                                              FirebaseFirestore.instance
                                                  .collection('admins')
                                                  .doc(doctorUid)
                                                  .collection('chats')
                                                  .doc(widget.user.uid)
                                                  .set(
                                                {
                                                  'chats':
                                                      FieldValue.arrayUnion(
                                                    [
                                                      {
                                                        'timestamp':
                                                            DateTime.now(),
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
                                                      builder: (context) =>
                                                          ChatScreen(
                                                        user: widget.user,
                                                        otherUser: doctorData,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        }, Colors.red, context),
                                      ),
                                      longButton(
                                        context: context,
                                        function: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  user: widget.user,
                                                  otherUser: doctorData),
                                            ),
                                          );
                                        },
                                        text: 'View Chats',
                                      ),
                                    ],
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                          else
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Text('No doctor added!'),
                                  TextButton(
                                    onPressed: null,
                                    child: Text('Add Doctor'),
                                  ),
                                ],
                              ),
                            );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container()
              // ChatScreen(user: widget.user, otherUser: doctorData)
            ],
          ),
        );
      }),
    );
  }
}

// class HomeUser extends StatefulWidget {
//   final Auth auth;
//   final UserData user;
//   HomeUser({required this.auth, required this.user});
//   @override
//   _HomeUserState createState() => _HomeUserState();
// }
//
// class _HomeUserState extends State<HomeUser> {
//   bool isLoading = false;
//   Location location = new Location();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout, color: Colors.white),
//             onPressed: () {
//               setState(
//                 () {
//                   isLoading = true;
//                 },
//               );
//               widget.auth.signOutGoogle().whenComplete(
//                 () {
//                   widget.user.getUserDetails().whenComplete(
//                     () {
//                       setState(
//                         () {
//                           isLoading = false;
//                         },
//                       );
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 RootPage(auth: widget.auth, user: widget.user),
//                           ),
//                           (route) => false);
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             bgWidget(
//               context: context,
//               child: Column(
//                 children: <Widget>[
//                   ProfileTile(
//                     user: widget.user,
//                     function: () {},
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 2,
//                     child: Container(color: Colors.blueGrey),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   longButton(
//                     context: context,
//                     function: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DistanceScreen(),
//                         ),
//                       );
//                     },
//                     text: 'Open Distance Page',
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 20.0, bottom: 10),
//                       child: Text(
//                         'Your Doctor',
//                         style: TextStyle(fontSize: 15),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 2,
//                     child: Container(color: Colors.blueGrey),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   FutureBuilder<DocumentSnapshot>(
//                     future: FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(widget.user.uid)
//                         .get(),
//                     builder:
//                         (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                       if (snapshot.hasData) {
//                         Map<String, dynamic> userMap =
//                             snapshot.data?.data() as Map<String, dynamic>;
//                         String doctorUid = userMap['doctorUid'] ?? '';
//                         if (doctorUid.isNotEmpty)
//                           return FutureBuilder(
//                             future: FirebaseFirestore.instance
//                                 .collection('admins')
//                                 .doc(doctorUid)
//                                 .get(),
//                             builder: (context,
//                                 AsyncSnapshot<DocumentSnapshot> snap) {
//                               if (snap.hasData) {
//                                 Map<String, dynamic> doctorMap =
//                                     snap.data?.data() as Map<String, dynamic>;
//                                 UserData doctorData =
//                                     new UserData.setFields(doctorMap);
//                                 return Column(
//                                   children: [
//                                     ProfileTile(
//                                       user: doctorData,
//                                       function: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => DoctorProfile(
//                                                 doctor: doctorData),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     longButton(
//                                       context: context,
//                                       function: () async {
//                                         setState(
//                                           () {
//                                             isLoading = true;
//                                           },
//                                         );
//                                         await location.getLocation().then(
//                                           (value) {
//                                             double? latitude = value.latitude;
//                                             double? longitude = value.longitude;
//                                             FirebaseFirestore.instance
//                                                 .collection('admins')
//                                                 .doc(doctorUid)
//                                                 .collection('chats')
//                                                 .doc(widget.user.uid)
//                                                 .set(
//                                               {
//                                                 'chats': FieldValue.arrayUnion(
//                                                   [
//                                                     {
//                                                       'timestamp':
//                                                           DateTime.now(),
//                                                       'latitude': latitude,
//                                                       'longitude': longitude,
//                                                       'sender': 'USER',
//                                                       'type': 'location',
//                                                     },
//                                                   ],
//                                                 ),
//                                               },
//                                             ).whenComplete(
//                                               () {
//                                                 setState(
//                                                   () {
//                                                     isLoading = false;
//                                                   },
//                                                 );
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ChatScreen(
//                                                       user: widget.user,
//                                                       otherUser: doctorData,
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                         );
//                                       },
//                                       text: 'Send SOS message',
//                                     ),
//                                     longButton(
//                                       context: context,
//                                       function: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ChatScreen(
//                                                 user: widget.user,
//                                                 otherUser: doctorData),
//                                           ),
//                                         );
//                                       },
//                                       text: 'View Chats',
//                                     ),
//                                   ],
//                                 );
//                               }
//                               return Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             },
//                           );
//                         else
//                           return Container(
//                             child: Column(
//                               children: <Widget>[
//                                 Text('No doctor added!'),
//                                 TextButton(
//                                   onPressed: null,
//                                   child: Text('Add Doctor'),
//                                 ),
//                               ],
//                             ),
//                           );
//                       }
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             overlayProgress(context: context, visible: isLoading),
//           ],
//         ),
//       ),
//     );
//   }
// }
