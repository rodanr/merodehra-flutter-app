import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:merodehra/services/gps_service.dart';
import 'dart:convert' as convert;
import 'package:url_launcher/url_launcher.dart';
import 'package:merodehra/services/utilities.dart';

class AdvertisementView extends StatefulWidget {
  final http.Response response;

  // ignore: non_constant_identifier_names
  final int advertisementId;
  final bool
      myFlag; // For showing add to card option in only search ads found view page

  // ignore: non_constant_identifier_names
  AdvertisementView({this.response, this.advertisementId, this.myFlag});

  @override
  _AdvertisementViewState createState() => _AdvertisementViewState();
}

class _AdvertisementViewState extends State<AdvertisementView> {
  String propertyType,
      geoLocation,
      propertyAddress,
      roomCount,
      propertyPrice,
      waterSource,
      terraceAccess,
      bathroomUsage,
      photoUrl,
      ownerName,
      propertyDescription;

  void updateUI() {
    setState(() {
      var responseBody = widget.response.body;
      var decodedData = convert.jsonDecode(responseBody);
      propertyType = decodedData['property_type'];
      propertyAddress = decodedData['property_address'];
      geoLocation = decodedData['geo_location'];
      roomCount = decodedData['room_count'].toString();
      propertyPrice = decodedData['price'].toString();
      waterSource = decodedData['water_source'];
      terraceAccess = decodedData['terrace_access'] == true ? "Yes" : "No";
      bathroomUsage = decodedData['bathroom'];
      photoUrl = decodedData['photo'];
      ownerName = decodedData['username'];
      propertyDescription = decodedData['description'];
    });
  }

  @override
  void initState() {
    // print(widget.advertisement_id);
    updateUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Changing Status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff1A1929),
      statusBarBrightness: Brightness.dark,
    ));
    _launchURL(String originLat, String originLong, String destLat,
        String destLong) async {
      String url =
          'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLong&destination=$destLat,$destLong&travelmode=driving&dir_action=navigate';
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.grey.shade300,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Image:",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    Container(
                      child: Image(
                        image: NetworkImage(photoUrl),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Property Type: $propertyType",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Address: $propertyAddress",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Total Rooms: $roomCount",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Price: Nrs $propertyPrice",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Water Source: $waterSource",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Terrace Access: $terraceAccess",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Bathroom Usage: $bathroomUsage",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.grey.shade200, fontSize: 20.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.all(8.0),
                      height: 150.0,
                      color: Color(0x556D304F),
                      child: Text(
                        "$propertyDescription",
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 15.0),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Posted By: $ownerName",
                      style: TextStyle(
                          color: Colors.grey.shade300, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: Color(0x556D304F),
                      onPressed: () async {
                        SeparateLatAndLong separator = SeparateLatAndLong();
                        LatLng destinationLocation =
                            separator.separateLatAndLong(geoLocation);
                        LatLng sourceLocation = await getSourceLocation();
                        _launchURL(
                            sourceLocation.latitude.toString(),
                            sourceLocation.longitude.toString(),
                            destinationLocation.latitude.toString(),
                            destinationLocation.longitude.toString());
                      },
                      child: Text("Get Directions",
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 20.0)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: widget.myFlag == true
            ? FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(
                  FontAwesomeIcons.cartPlus,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            : null,
      ),
    );
  }
}
