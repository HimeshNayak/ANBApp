import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

import '../models/user.dart';
import '../services/auth.dart';
import '../style/fonts.dart';
import '../widgets/commonWidgets.dart';
import '../widgets/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import '../main.dart';

class PatientProfile extends StatefulWidget {
  final Auth auth;
  final UserData user;
  final bool isAdmin;

  PatientProfile(
      {required this.auth, required this.user, required this.isAdmin});

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool isLoading = false;
  bool showEditField = false;
  TextEditingController nameController = new TextEditingController();

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
              (route) => false,
            );
          },
        );
      },
    );
  }

  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;
  String? _imageName = '';
  String? get imageName => _imageName;
  File? _filePath;
  File? get filePath => _filePath;
  String? uploadedImageUrl = '';

  Future<void> openCamera() async {
    final imagePicker = ImagePicker();

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      _pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
      if (_pickedFile != null) {
        _filePath = File(_pickedFile?.path as String);
        _imageName = _filePath?.uri.path.split('/').last;
        print(_filePath);
        print(_imageName);
      } else {
        print("Please pick Image");
      }
    } else {
      print('Permission Granted');
    }
  }

  Future<fs.UploadTask?> sendImageToFirebase() async {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return null;
    }

    fs.UploadTask uploadTask;

    // Create a Reference to the file
    fs.Reference ref = fs.FirebaseStorage.instance
        .ref()
        .child(widget.user.email.toString())
        .child('/$_imageName');

    final metadata = fs.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _pickedFile?.path as String});

    uploadTask = ref.putFile(File(_pickedFile?.path as String), metadata);

    print('uploading completed!!!');

    return Future.value(uploadTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(widget.user.photoUrl!),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                openCamera().whenComplete(() {
                                  sendImageToFirebase().then((value) {
                                    value?.then((v) {
                                      v.ref.getDownloadURL().then((value) {
                                        print(value);
                                      }).whenComplete(() {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                    });
                                  });
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !showEditField,
                          child: Text(
                            widget.user.userName!,
                            style: heading1Bl,
                          ),
                        ),
                        Visibility(
                          visible: showEditField,
                          child: Container(
                            width: 200,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: widget.user.userName!,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              showEditField = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showEditField,
                    child: button1('Save', () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (nameController.value.text.isNotEmpty) {
                        await SharedPreferences.getInstance().then((_prefs) {
                          _prefs.setString(
                              'userName', nameController.value.text);
                        });
                        await FirebaseFirestore.instance
                            .collection((widget.isAdmin) ? 'admins' : 'users')
                            .doc(widget.user.uid)
                            .update({
                          'username': nameController.value.text.toString(),
                        }).whenComplete(() {
                          setState(() {
                            isLoading = false;
                            showEditField = false;
                          });
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RootPage(
                                    auth: widget.auth, user: widget.user),
                              ),
                              (route) => false);
                        });
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        print('Name is empty!!! Please enter your name');
                      }
                    }, Colors.greenAccent, context),
                  ),
                  Visibility(
                    visible: showEditField,
                    child: button1('Cancel', () {
                      setState(() {
                        showEditField = false;
                      });
                    }, Colors.red, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        (widget.user.email!).toString(),
                        style: heading2Bl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: button1('Logout', logoutFn, Colors.red, context),
                  )
                ],
              ),
            ),
            overlayProgress(context: context, visible: isLoading)
          ],
        ),
      ),
    );
  }
}
