import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:swinger_iot/screens/patientProfile.dart';
import 'package:swinger_iot/style/fonts.dart';
import 'package:swinger_iot/widgets/widgets.dart';

import '../models/user.dart';
import '../screens/chatScreen.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';
import 'package:google_fonts/google_fonts.dart';

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
  // Location location = new Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                              NetworkImage(widget.doctor.photoUrl!),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          widget.doctor.userName!,
                          style: heading1Bl,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            (widget.doctor.email!).toString(),
                            style: heading2Bl,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                          ),
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text('SOS',
                                    style: GoogleFonts.comfortaa(
                                        textStyle: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                              ),
                            ),
                            onTap: () async {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );
                              await new Location()
                                  .getLocation()
                                  .timeout(Duration(milliseconds: 5000))
                                  .onError((error, stackTrace) =>
                                      throw error.toString())
                                  .catchError((err) {
                                print(err);
                                FirebaseFirestore.instance
                                    .collection('admins')
                                    .doc(widget.doctor.uid)
                                    .collection('chats')
                                    .doc(widget.user.uid)
                                    .update(
                                  {
                                    'chats': FieldValue.arrayUnion(
                                      [
                                        {
                                          'timestamp': DateTime.now(),
                                          'text': 'SOS tapped',
                                          'sender': 'USER',
                                          'type': 'text',
                                        },
                                      ],
                                    ),
                                  },
                                );
                              }).then(
                                (value) {
                                  if (value != null) {
                                    double? latitude = value.latitude;
                                    double? longitude = value.longitude;
                                    print(latitude);
                                    print(longitude);
                                    FirebaseFirestore.instance
                                        .collection('admins')
                                        .doc(widget.doctor.uid)
                                        .collection('chats')
                                        .doc(widget.user.uid)
                                        .update(
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
                                    );
                                  }
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
                          ),
                        ),
                      ),
                      button1('View Chats', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              user: widget.user,
                              otherUser: widget.doctor,
                            ),
                          ),
                        );
                      }, Colors.greenAccent, context),
                    ],
                  ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientProfile(
                        auth: widget.auth,
                        user: widget.user,
                        doctor: widget.doctor,
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
    );
  }
}
