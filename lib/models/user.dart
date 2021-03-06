import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String? userName, email, uid, photoUrl, type, fcmToken;

  UserData() {
    getUserDetails();
  }

  UserData.setFields(Map<String, dynamic> map) {
    uid = map['uid'];
    userName = map['username'];
    email = map['email'];
    photoUrl = map['photoUrl'];
    type = map['type'];
    fcmToken = map['fcmToken'];
  }

  Future<void> getUserDetails() async {
    await SharedPreferences.getInstance().then((_prefs) {
      userName = _prefs.getString('userName');
      email = _prefs.getString('email');
      uid = _prefs.getString('uid');
      photoUrl = _prefs.getString('photoUrl');
      type = _prefs.getString('type') ?? 'LOGIN';
      fcmToken = _prefs.getString('fcmToken');
    });
    return;
  }

  Future<String?> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _type = prefs.getString('type');
    return _type;
  }
}
