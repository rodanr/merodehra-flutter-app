import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merodehra/main.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  @override
  void deactivate() {
    SystemNavigator.pop();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Text("Username: " + context.watch<UserData>().username),
                Text("Email: " + context.watch<UserData>().email),
                Text("Mobile Number: " +
                    context.watch<UserData>().mobile_number),
                FlatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('loginStatus', false);
                    // closing app on logout
                    deactivate();

                  },
                  child: Text("Log out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
