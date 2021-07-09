import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhoto {
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

  Future<fs.UploadTask?> sendImageToFirebase(
      BuildContext context, String email) async {
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
    fs.Reference ref =
        fs.FirebaseStorage.instance.ref().child(email).child('/$_imageName');

    final metadata = fs.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _pickedFile?.path as String});

    uploadTask = ref.putFile(File(_pickedFile?.path as String), metadata);

    return Future.value(uploadTask);
  }

  Future<void> updateImageUrl(bool isAdmin, String uid, String url) async {
    await FirebaseFirestore.instance
        .collection((isAdmin) ? 'admins' : 'users')
        .doc(uid)
        .get()
        .then((value) {
      String url = value.data()!['photoUrl'];
      deletePreviousPhoto(url).whenComplete(() async {
        await FirebaseFirestore.instance
            .collection((isAdmin) ? 'admins' : 'users')
            .doc(uid)
            .update({'photoUrl': url});
      });
    });
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('photoUrl', url);
    });
  }

  Future<void> deletePreviousPhoto(String url) async {
    try {
      return await fs.FirebaseStorage.instance
          .refFromURL(url)
          .delete()
          .catchError((e) {
        print('couldn\'t delete ' + e.toString());
      });
    } catch (e) {
      print('error occurred!');
    }
  }
}
