import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merodehra/views/login_page.dart';
import 'package:merodehra/views/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool loginFlag;

  void getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginFlag = prefs.getBool('loginStatus');
    if (loginFlag == true) {
      // opens user dashboard
      context.read<UserData>().updateUserName(prefs.getString('username'));
      context.read<UserData>().updateEmail(prefs.getString('email'));
      context
          .read<UserData>()
          .updateMobileNumber(prefs.getString('mobile_number'));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return UserDashBoard();
      }));
    } else {
      // Opens Login Page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }
  }

  @override
  void initState() {
    getLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: <Color>[
                Color(0xff1A1929),
                Color(0xff2D1D40),
                Color(0xff6D304F),
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(30.0),
                  child: Image(
                    image: AssetImage("images/icon.png"),
                    height: 128,
                    width: 128,
                    color: Color(0xff1A1929),
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
                SizedBox(
                  height: 150.0,
                ),
                SpinKitRing(
                  color: Colors.grey.shade700,
                  size: 50.0,
                  lineWidth: 4.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
