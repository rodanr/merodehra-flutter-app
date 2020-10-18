import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merodehra/views/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';
import 'package:merodehra/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:merodehra/views/user_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String username, password;
bool _obscureText = true;
bool _showSpinner = false;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Icon _getEyeIcon() {
    if (_obscureText == true) {
      return Icon(
        Icons.remove_red_eye,
        color: Colors.grey,
        size: 20.0,
      );
    } else {
      return Icon(
        Icons.remove_red_eye_outlined,
        color: Colors.white,
        size: 20.0,
      );
    }
  }

  //
  // @override
  // void deactivate() {
  //   SystemNavigator.pop();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    // Changing Status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff1A1929),
      statusBarBrightness: Brightness.dark,
    ));
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // resizeToAvoidBottomPadding: false, -> this code disable the scroll feature of SingleChildScrollView
        body: Builder(
          builder: (ctx) => SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: _showSpinner,
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
                // Expanding the container to fill the whole screen
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.home_work_rounded,
                          color: Color(0xff2A376E),
                          size: 50.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30.0),
                        child: Text(
                          "Log in",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: TextField(
                          onChanged: (value) {
                            username = value;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: new InputDecoration(
                            labelText: "username",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                            filled: true,
                            fillColor: Color(0xff2D1D40),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        child: TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: new InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: _togglePasswordView,
                                child: _getEyeIcon()),
                            labelText: "password",
                            labelStyle: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                            filled: true,
                            fillColor: Color(0xff2D1D40),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          ),
                          obscureText: _obscureText,
                        ),
                      ),
                      // Login Button
                      SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xff252335),
                              Color(0xff242436),
                            ],
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            //closing keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            //showing spinner
                            setState(() {
                              _showSpinner = true;
                            });
                            // context.read<UserData>().updateUserName(username);
                            // context.read<UserData>().updatePassword(password);
                            // SnackBar snackbar = SnackBar(
                            //   content: new Text("Signed up Successfully"),
                            // );
                            // Scaffold.of(ctx).showSnackBar(snackbar);
                            UserManagement login = UserManagement();
                            http.Response response =
                                await login.login(username, password);
                            if (response.statusCode == 200 ||
                                response.statusCode == 400) {
                              var responseBody = response.body;
                              var decodedData =
                                  convert.jsonDecode(responseBody);
                              if (response.statusCode == 200) {
                                context
                                    .read<UserData>()
                                    .setUserId(decodedData['user_id']);
                                context
                                    .read<UserData>()
                                    .updateUserName(decodedData['username']);
                                context
                                    .read<UserData>()
                                    .updateEmail(decodedData['email']);
                                context.read<UserData>().updateMobileNumber(
                                    decodedData['mobile_number']);
                                // setting the flag that user has logged
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('loginStatus', true);
                                setState(() {
                                  _showSpinner = false;
                                });
                                String message = decodedData['message'];
                                SnackBar snackbar = SnackBar(
                                  content: new Text(message),
                                  backgroundColor: Colors.greenAccent,
                                );
                                Scaffold.of(ctx).showSnackBar(snackbar);
                                // waiting 1 seconds to show log in successful message
                                await Future.delayed(Duration(seconds: 1));
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserDashBoard();
                                }));
                              } else {
                                setState(() {
                                  _showSpinner = false;
                                });
                                // print("else runned");
                                String message = decodedData['message'];
                                SnackBar snackbar = SnackBar(
                                  content: new Text(message),
                                  backgroundColor: Colors.redAccent,
                                );
                                Scaffold.of(ctx).showSnackBar(snackbar);
                                await Future.delayed(Duration(seconds: 1));
                              }
                            }
                          },
                          child: Text(
                            "Log in",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          height: 50.0,
                          minWidth: 200.0,
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Don't have an account?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0xff90A3B9),
                                fontSize: 13.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SignUpPage();
                                }));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Sign up ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
