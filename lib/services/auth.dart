import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      await SharedPreferences.getInstance().then((_prefs) {
        _prefs.setString('userName', user.displayName.toString());
        _prefs.setString('email', user.email.toString());
        _prefs.setString('uid', user.uid.toString());
        _prefs.setString('photoUrl', user.photoURL.toString());
        _prefs.setString('type', 'USER');
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
      await SharedPreferences.getInstance().then((_prefs) {
        _prefs.setString('userName', 'Doctor Admin');
        _prefs.setString('email', user.email.toString());
        _prefs.setString('uid', user.uid.toString());
        _prefs.setString('photoUrl',
            'https://webstockreview.net/images/clipart-doctor-person-1.png');
        _prefs.setString('type', 'ADMIN');
      });
    }
    return user;
  }

  Future signOut() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    _prefs.setString('type', 'LOGIN');
    return await _auth.signOut();
  }

  Future signOutGoogle() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.clear();
    _prefs.setString('type', 'LOGIN');
    _auth.signOut();
    googleSignIn.signOut();
  }
}
