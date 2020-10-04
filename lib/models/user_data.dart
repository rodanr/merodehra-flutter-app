import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData with ChangeNotifier, DiagnosticableTreeMixin {
  // ignore: non_constant_identifier_names
  String username, email, mobile_number, password;

  void updateUserName(String newUserName) async {
    this.username = newUserName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // avoiding redundant prefs set
    if (this.username != prefs.getString('username')) {
      prefs.setString('username', this.username);
    }
    notifyListeners();
  }

  void updateEmail(String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.email = newEmail;
    if (this.email != prefs.getString('email')) {
      prefs.setString('email', this.email);
    }
    notifyListeners();
  }

  void updateMobileNumber(String newMobileNumber) async {
    this.mobile_number = newMobileNumber;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.mobile_number != prefs.getString('mobile_number')) {
      prefs.setString('mobile_number', this.mobile_number);
    }
    notifyListeners();
  }

  void updatePassword(String newPassword) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    this.password = newPassword;
    // prefs.setString('password', this.password);
    print(this.password);
    notifyListeners();
  }
}
