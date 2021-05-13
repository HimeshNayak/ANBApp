class User {
  String userName = '', email = '', uid = '';
  var type;
  User() {
    getUserDetails();
  }
  Future<void> getUserDetails() async {
    type = 'ADMIN';
    return;
  }
}
