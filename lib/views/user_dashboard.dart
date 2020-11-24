import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merodehra/services/user_service.dart';
import 'package:merodehra/views/find_ads_page_and_homepage.dart';
import 'package:merodehra/views/login_page.dart';
import 'package:merodehra/views/notification_page.dart';
import 'package:merodehra/views/put_ads_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:merodehra/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class UserDashBoard extends StatefulWidget {
  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  String searchedLocation;

  // For navigation hover
  int selectedIndex = 0;

  // For indexing the stack widget
  int _selectedPage = 0;
  List<Widget> pageList = List<Widget>();
  String profilePictureUrl;
  File image;
  bool _showSpinner = false;

  Future getImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    File tempImage = File(pickedFile.path);
    setState(() {
      image = tempImage;
    });
  }

  Future<void> fetchProfilePicUrl() async {
    String fetchedUrl =
        await fetchProfilePictureUrl(context.read<UserData>().user_id);
    setState(() async {
      profilePictureUrl = fetchedUrl;
    });
    context.read<UserData>().updatePhotoUrl(profilePictureUrl);
    print(profilePictureUrl);
  }

  String generateImageFileName() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd-kk:mm:ss');
    String formatted = formatter.format(now);
    // print(formatted);
    return formatted;
  }

  Future<String> uploadImage(File image) async {
    String fileName = generateImageFileName();
    await firebase_storage.FirebaseStorage.instance
        .ref(fileName + '.jpg')
        .putFile(image);
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(fileName + '.jpg')
        .getDownloadURL();
    // print(downloadURL);
    return downloadURL;
  }

  void updateUI() async {
    await fetchProfilePicUrl();
  }

  @override
  void initState() {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    if (profilePictureUrl == "NULL" ||
        profilePictureUrl == "" ||
        profilePictureUrl == null){
      updateUI();
    }
    pageList.add(FindAdsPage());
    pageList.add(PutAdsPage());
    pageList.add(NotificationPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    void _onBottomNavigationBarItemTapped(newValue) {
      setState(() {
        selectedIndex = newValue;
        _selectedPage = newValue;
      });
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Scaffold(
          drawer: Drawer(
            child: SafeArea(
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await getImage();
                          setState(() {
                            _showSpinner = true;
                          });
                          profilePictureUrl = await uploadImage(image);
                          await postProfilePictureUrl(context.read<UserData>().user_id, profilePictureUrl);
                          setState(() {
                            updateUI();
                          });
                          setState(() {
                            _showSpinner = false;
                          });
                        },
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: profilePictureUrl == "NULL" ||
                                  profilePictureUrl == "" ||
                                  profilePictureUrl == null
                              ? AssetImage('images/no_photo.jpg')
                              : NetworkImage(profilePictureUrl),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        context.watch<UserData>().username +
                            "#" +
                            (context.watch<UserData>().user_id).toString(),
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 40.0, 0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                color: Colors.blue,
                              ),
                              title: Text(
                                context.watch<UserData>().email,
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  //TODO: Implement Change email
                                },
                                child: Icon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.blueAccent,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.phone_circle_fill,
                                color: Colors.green,
                              ),
                              title:
                                  Text(context.watch<UserData>().mobile_number),
                              trailing: GestureDetector(
                                onTap: () {
                                  //TODO: Implement Change mobile number
                                },
                                child: Icon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.greenAccent,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('loginStatus', false);
                          // closing app on logout
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(
                          "Log out",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Builder(
            builder: (ctx) => Container(
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
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: RawMaterialButton(
                          onPressed: () {
                            //onTap of GestureDetector does the job
                            Scaffold.of(ctx).openDrawer();
                          },
                          fillColor: Color(0xaa2D1D40),
                          shape: CircleBorder(),
                          constraints: BoxConstraints.tightFor(
                            height: 40,
                            width: 40,
                          ),
                          child: Icon(FontAwesomeIcons.bars)),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _selectedPage,
                        children: pageList,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xaa6D304F),
            currentIndex: selectedIndex,
            onTap: _onBottomNavigationBarItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.searchengin),
                  label: "Search Ads"),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.ad), label: "Put Ads"),
              BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.solidBell),
                  label: "Notifications"),
            ],
          ),
        ),
      ),
    );
  }
}
