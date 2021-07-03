import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../services/auth.dart';
import '../widgets/commonWidgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class DoctorListScreen extends StatefulWidget {
  final Auth auth;
  final UserData userData;
  DoctorListScreen({required this.auth, required this.userData});
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('admins')
                    .get()
                    .asStream(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return listBuilder(snapshot.data?.docs);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
            overlayProgress(context: context, visible: isLoading)
          ],
        ),
      ),
    );
  }

  Widget listBuilder(List<QueryDocumentSnapshot>? docs) {
    return ListView.builder(
      itemCount: docs?.length,
      itemBuilder: (context, item) {
        return doctorContainer(docs?[item].data());
      },
    );
  }

  Widget doctorContainer(dynamic map) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(map['photoUrl'].toString()),
          radius: 30,
        ),
        title: Text(
          map['username'],
        ),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            await FirebaseFirestore.instance
                .collection('admins')
                .doc(map['uid'])
                .update({
              'patients': FieldValue.arrayUnion([widget.userData.uid]),
            });
            await FirebaseFirestore.instance
                .collection('admins')
                .doc(map['uid'])
                .collection('chats')
                .doc(widget.userData.uid)
                .set({
              'chats': [],
            });
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userData.uid)
                .update({
              'doctorUid': map['uid'],
            }).whenComplete(() => setState(() {
                      isLoading = false;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RootPage(
                              auth: widget.auth, user: widget.userData),
                        ),
                        (route) => false,
                      );
                    }));
          },
        ),
      ),
    );
  }
}
