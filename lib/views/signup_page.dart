import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';
import 'package:merodehra/services/user_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String username, email, mobileNumber, password;
bool _obscureText = true;
bool _showSpinner = false;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  @override
  Widget build(BuildContext context) {
    // Changing Status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff1A1929),
      statusBarBrightness: Brightness.dark,
    ));
    return Scaffold(
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
                        "Sign up",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: TextFormField(
                        onChanged: (value) {
                          username = value;
                          print(value);
                        },
                        decoration: new InputDecoration(
                          labelText: "username",
                          hintText: "your username",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                          filled: true,
                          fillColor: Color(0x802D1D40),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          return (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value))
                              ? 'Invalid Characters'
                              : null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: new InputDecoration(
                          labelText: "email",
                          hintText: "email@email.com",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                          filled: true,
                          fillColor: Color(0x802D1D40),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          return !value.contains('@') ? 'Invalid email' : null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: TextFormField(
                        onChanged: (value) {
                          mobileNumber = value;
                        },
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        decoration: new InputDecoration(
                          labelText: "mobile number",
                          hintText: "your mobile number",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                          filled: true,
                          fillColor: Color(0x802D1D40),
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
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                      child: TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: new InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: _togglePasswordView, child: _getEyeIcon()),
                          labelText: "password",
                          hintText: "make a strong password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                          filled: true,
                          fillColor: Color(0x802D1D40),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                        ),
                        obscureText: _obscureText,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          return value.length < 8
                              ? "Password Must be 8 Character long or more"
                              : null;
                        },
                      ),
                    ),
                    // Login Button
                    SizedBox(
                      height: 30.0,
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
                          UserManagement signUp = UserManagement();
                          http.Response response = await signUp.signUp(
                              username, email, mobileNumber, password);
                          setState(() {
                            _showSpinner = false;
                          });
                          if (response.statusCode == 200 ||
                              response.statusCode == 400) {
                            // signUp successful
                            setState(() async {
                              var responseBody = response.body;
                              var decodedData =
                                  convert.jsonDecode(responseBody);
                              String message = decodedData['message'];
                              SnackBar snackbar = SnackBar(
                                content: new Text(message),
                                backgroundColor: Colors.greenAccent,
                              );
                              Scaffold.of(ctx).showSnackBar(snackbar);
                              // delaying or sleeping to show the message as context will be popped without getting the snackbar message on the screen
                              await Future.delayed(Duration(seconds: 1));
                              if (response.statusCode == 200) {
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            // signUp not successful
                            // stopping spinner
                            _showSpinner = false;
                            setState(() {
                              SnackBar snackbar = SnackBar(
                                content:
                                    new Text("Sign up error. Check Connection"),
                                backgroundColor: Colors.redAccent,
                              );
                              Scaffold.of(ctx).showSnackBar(snackbar);
                            });
                          }
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        height: 50.0,
                        minWidth: 200.0,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10.0),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Already have an account?",
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
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Log in ",
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
