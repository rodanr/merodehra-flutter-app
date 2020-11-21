import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AdvertisementView extends StatefulWidget {
  final http.Response response;

  AdvertisementView({this.response});

  @override
  _AdvertisementViewState createState() => _AdvertisementViewState();
}

class _AdvertisementViewState extends State<AdvertisementView> {
  String propertyType,
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
