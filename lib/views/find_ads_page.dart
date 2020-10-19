import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:merodehra/views/ads_found_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert' as convert;
import 'package:merodehra/services/advertisement_service.dart';

class FindAdsPage extends StatefulWidget {
  @override
  _FindAdsPageState createState() => _FindAdsPageState();
}

String locationToSearch;
bool _showSpinner = false;
String message;

class _FindAdsPageState extends State<FindAdsPage> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                  child: Text(
                    "Find Property",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 40.0, 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 15,
                        child: TextField(
                          onChanged: (value) {
                            locationToSearch = value;
                          },
                          decoration: new InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            prefixIcon: Icon(
                              FontAwesomeIcons.locationArrow,
                              color: Colors.blue,
                            ),
                            hintText: "Type Location",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue.shade500),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () async {
                            //closing keyboard
                            FocusScope.of(context).requestFocus(FocusNode());
                            // print("flat button pressed");
                            setState(() {
                              _showSpinner = true;
                            });
                            AdvertisementManagement searchAdvertisement =
                                new AdvertisementManagement();
                            http.Response response = await searchAdvertisement
                                .searchAdvertisement(locationToSearch);
                            if (response.statusCode == 200) {
                              var responseBody = response.body;
                              var decodedData =
                                  convert.jsonDecode(responseBody);
                              var advertisementList =
                                  decodedData['advertisement_list'];
                              setState(() {
                                _showSpinner = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AdsFoundPage(
                                  advertisementList: advertisementList,
                                );
                              }));
                            } else {
                              message = "Trouble Finding Ads";
                              print(message);
                            }
                          },
                          child: Container(
                            child: Icon(
                              FontAwesomeIcons.searchLocation,
                              color: Colors.blue.shade500,
                              size: 40.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.shoppingCart,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text("Ads Cart")
                            ],
                          ),
                          SizedBox(
                            width: 35.0,
                          ),
                          Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.ad,
                                color: Colors.green,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text("Your Ads")
                            ],
                          ),
                          SizedBox(
                            width: 35.0,
                          ),
                          Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.key,
                                color: Colors.yellow.shade700,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text("Requests")
                            ],
                          ),
                          SizedBox(
                            width: 35.0,
                          ),
                          Column(
                            children: [
                              Icon(
                                FontAwesomeIcons.rocketchat,
                                color: Colors.red.shade500,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text("Chats")
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
