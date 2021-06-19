import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async {
    // ignore: await_only_futures
    return await _auth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user != null) {
      await SharedPreferences.getInstance().then(
        (_prefs) {
          _prefs.setString('userName', user.displayName.toString());
          _prefs.setString('email', user.email.toString());
          _prefs.setString('uid', user.uid.toString());
          _prefs.setString('photoUrl', user.photoURL.toString());
          _prefs.setString('type', 'USER');
          // not adding users fcm token to the shared preferences as it is not needed here
        },
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        if (!value.exists) {
          String? fcmToken;
          FirebaseMessaging.instance.getToken().then(
            (token) {
              fcmToken = token;
            },
          ).whenComplete(
            () {
              FirebaseFirestore.instance.collection('users').doc(user.uid).set(
                {
                  'username': user.displayName.toString(),
                  'email': user.email.toString(),
                  'uid': user.uid.toString(),
                  'photoUrl': user.photoURL.toString(),
                  'doctorUid': '',
                  'chatOptions': [
                    'Please send an ambulance ASAP!',
                    'I need a First Aid Now!'
                  ],
                  'fcmToken': fcmToken,
                  'type': 'USER'
                },
              );
            },
          );
        } else {
          String? fcmToken;
          FirebaseMessaging.instance.getToken().then(
            (token) {
              fcmToken = token;
            },
          ).whenComplete(
            () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update(
                {'fcmToken': fcmToken},
              );
            },
          );
        }
      });
    }
    return user;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential authCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = authCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get()
          .then(
        (value) async {
          if (value.exists) {
            Map<dynamic, dynamic>? map = value.data();
            await SharedPreferences.getInstance().then(
              (_prefs) {
                if (map != null) {
                  _prefs.setString('userName', map['username'].toString());
                  _prefs.setString('email', user.email.toString());
                  _prefs.setString('uid', user.uid.toString());
                  _prefs.setString('photoUrl', map['photoUrl'].toString());
                  _prefs.setString('type', 'ADMIN');
                  // not adding users fcm token to the shared preferences as it is not needed here
                }
              },
            );
            String? fcmToken;
            await FirebaseMessaging.instance.getToken().then(
              (token) async {
                print(token);
                fcmToken = token;
              },
            ).whenComplete(
              () {
                FirebaseFirestore.instance
                    .collection('admins')
                    .doc(user.uid)
                    .update(
                  {'fcmToken': fcmToken},
                );
              },
            );
          }
        },
      );
    }
    return user;
  }

  Future<User?> createUserEmailPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = userCredential.user;
    if (user != null) {
      await SharedPreferences.getInstance().then(
        (_prefs) {
          _prefs.setString('userName', 'Enter Name');
          _prefs.setString('email', user.email.toString());
          _prefs.setString('uid', user.uid.toString());
          _prefs.setString('photoUrl',
              'https://webstockreview.net/images/clipart-doctor-person-1.png');
          _prefs.setString('type', 'ADMIN');
          // not adding users fcm token to the shared preferences as it is not needed here
        },
      );
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get()
          .then(
        (value) {
          if (!value.exists) {
            String? fcmToken;
            FirebaseMessaging.instance.getToken().then(
              (token) async {
                fcmToken = token;
              },
            ).whenComplete(
              () {
                FirebaseFirestore.instance
                    .collection('admins')
                    .doc(user.uid)
                    .set(
                  {
                    'username': 'Enter Name',
                    'email': user.email.toString(),
                    'uid': user.uid.toString(),
                    'photoUrl':
                        'https://webstockreview.net/images/clipart-doctor-person-1.png',
                    'patients': [],
                    'chatOptions': [
                      'We are sending an Ambulance!',
                      'We are committed to help you in any way possible.'
                    ],
                    'fcmToken': fcmToken,
                    'type': 'ADMIN'
                  },
                );
              },
            );
          }
        },
      );
    }
    return user;
  }

  Future signOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    _prefs.setString('type', 'LOGIN');
    String? uid = _auth.currentUser?.uid;
    await FirebaseFirestore.instance.collection('admins').doc(uid).update(
      {'fcmToken': ''},
    );
    return await _auth.signOut();
  }

  Future signOutGoogle() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    _prefs.setString('type', 'LOGIN');
    String? uid = _auth.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update(
      {'fcmToken': ''},
    );
    _auth.signOut();
    googleSignIn.signOut();
  }
}
