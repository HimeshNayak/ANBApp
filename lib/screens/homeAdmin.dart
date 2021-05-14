import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../screens/patientProfile.dart';
import '../services/auth.dart';
import '../services/root.dart';
import '../widgets/commonWidgets.dart';
import '../widgets/profileTile.dart';

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
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              widget.auth.signOut().whenComplete(() {
                widget.user.getUserDetails().whenComplete(() {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RootPage(auth: widget.auth, user: widget.user)),
                      (route) => false);
                });
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            bgWidget(
              context: context,
              child: Column(
                children: [
                  ProfileTile(
                    user: widget.user,
                    function: () {},
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Patients',
                            style: TextStyle(fontSize: 15),
                          ),
                          OutlinedButton(
                            onPressed: null,
                            child: Text('View Requests'),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 2, child: Container(color: Colors.blueGrey)),
                  SizedBox(
                    height: 10,
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
                        return Center(child: CircularProgressIndicator());
                      }),
                ],
              ),
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
                  UserData userData = new UserData();
                  userData.setFields(userMap);
                  return ProfileTile(
                    user: userData,
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientProfile()));
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              });
        },
      );
    else
      return Container(
        child: Text('No Patient Added!'),
      );
  }
}
