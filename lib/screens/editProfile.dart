import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../widgets/commonWidgets.dart';

class EditProfile extends StatefulWidget {
  final UserData user;
  EditProfile({required this.user});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),
                OutlinedButton(
                  child: Text('Save'),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (nameController.value.text.isNotEmpty) {
                      await SharedPreferences.getInstance().then((_prefs) {
                        _prefs.setString('userName', nameController.value.text);
                      });
                      await FirebaseFirestore.instance
                          .collection('admins')
                          .doc(widget.user.uid)
                          .update({
                        'username': nameController.value.text.toString(),
                      }).whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      print('Name is empty!!! Please enter your name');
                    }
                  },
                ),
              ],
            ),
            overlayProgress(context: context, visible: isLoading)
          ],
        ),
      ),
    );
  }
}
