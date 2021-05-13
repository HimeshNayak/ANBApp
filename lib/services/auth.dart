import '../models/user.dart';

class Auth {
  Future<String?> getUser() async {
    return User().type;
  }
}
