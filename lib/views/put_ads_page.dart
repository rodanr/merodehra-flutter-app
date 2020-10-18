import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';
import 'package:merodehra/services/advertisement_service.dart';
import 'package:merodehra/services/gps_service.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert' as convert;

enum PropertyType { room, flat }
enum BathroomUsage { private, shared }

String propertyAddress,
    geoLocation,
    roomCount,
    propertyDescription,
    waterSource;
bool terraceAccess = false;
double propertyPrice;
String message;

bool _showSpinner = false;

class PutAdsPage extends StatefulWidget {
  @override
  _PutAdsPageState createState() => _PutAdsPageState();
}

class _PutAdsPageState extends State<PutAdsPage> {
  List<Asset> images = List<Asset>();
  String _error;
  PropertyType selectedPropertyType = PropertyType.room;
  BathroomUsage selectedBathroomUsage = BathroomUsage.private;

  Widget buildGridView() {
    if (images != null)
      return SliverGrid.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
      _error = _error;
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Detected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: FlatButton(
                        padding: EdgeInsets.all(5.0),
                        onPressed: loadAssets,
                        child: ListTile(
                          dense: true,
                          title: Text(
                            "Click here to upload images",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          trailing: Icon(
                            FontAwesomeIcons.upload,
                            color: Colors.yellow,
                          ),
                        ),
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              buildGridView(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    //PropertyTypeSelection
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Property Type: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 7,
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton<String>(
                              value: selectedPropertyType == PropertyType.room
                                  ? "Room"
                                  : "Flat",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  if (newValue == "Room") {
                                    selectedPropertyType = PropertyType.room;
                                  } else {
                                    selectedPropertyType = PropertyType.flat;
                                  }
                                  // print(selectedPropertyType);
                                });
                              },
                              items: <String>[
                                'Room',
                                'Flat'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ), //PropertyTypeSelection
                    //PropertyAddressInput
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Property Address: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                propertyAddress = value;
                              },
                              decoration: new InputDecoration(
                                  hintText: "Your property Address"),
                            ),
                            flex: 5,
                          ),
                        ],
                      ),
                    ),
                    //Getting number of rooms
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Rooms: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                roomCount = value;
                              },
                              decoration: new InputDecoration(
                                  hintText: "Number of rooms"),
                            ),
                            flex: 5,
                          ),
                        ],
                      ),
                    ),
                    //Price
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Price: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                propertyPrice = double.parse(value);
                              },
                              decoration: new InputDecoration(
                                prefixText: "NRS.",
                                prefixStyle: TextStyle(color: Colors.white),
                                hintText: "Enter Price",
                              ),
                            ),
                            flex: 5,
                          ),
                        ],
                      ),
                    ),
                    //PropertyDescription
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Property Description",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          TextFormField(
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              propertyDescription = value;
                            },
                            decoration: new InputDecoration(
                              prefixStyle: TextStyle(color: Colors.white),
                              hintText: "Description about the property",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //GettingWaterSource
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Water Source: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                waterSource = value;
                              },
                              decoration: new InputDecoration(
                                prefixStyle: TextStyle(color: Colors.white),
                                hintText: "Sources of water",
                              ),
                            ),
                            flex: 5,
                          ),
                        ],
                      ),
                    ),
                    //GettingTerraceBoolValue
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Terrace Access: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 8,
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton<String>(
                              value: terraceAccess == true ? "Yes" : "No",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  if (newValue == "Yes") {
                                    setState(() {
                                      terraceAccess = true;
                                    });
                                  } else {
                                    setState(() {
                                      terraceAccess = false;
                                    });
                                  }
                                  // print(selectedPropertyType);
                                });
                              },
                              items: <String>[
                                'Yes',
                                'No'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //GettingBathroomStatus
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Bathroom Usage: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            flex: 8,
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButton<String>(
                              value:
                                  selectedBathroomUsage == BathroomUsage.private
                                      ? "Private"
                                      : "Shared",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  if (newValue == "Private") {
                                    setState(() {
                                      selectedBathroomUsage =
                                          BathroomUsage.private;
                                    });
                                  } else {
                                    setState(() {
                                      selectedBathroomUsage =
                                          BathroomUsage.shared;
                                    });
                                  }
                                  // print(selectedPropertyType);
                                });
                              },
                              items: <String>[
                                'Private',
                                'Shared'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.blue.shade800,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: FlatButton(
                          onPressed: () async {
                            setState(() {
                              _showSpinner = true;
                            });
                            geoLocation = await getGPSLocation();
                            print(geoLocation);
                            AdvertisementManagement postAdvertisement =
                                new AdvertisementManagement();
                            http.Response response =
                                await postAdvertisement.postAdvertisement(
                                    selectedPropertyType == PropertyType.room
                                        ? "Room"
                                        : "Flat",
                                    propertyAddress,
                                    geoLocation,
                                    roomCount,
                                    propertyPrice,
                                    propertyDescription,
                                    waterSource,
                                    selectedBathroomUsage ==
                                            BathroomUsage.private
                                        ? "Private"
                                        : "Shared",
                                    terraceAccess);
                            if (response.statusCode == 200) {
                              var responseBody = response.body;
                              var decodedData =
                                  convert.jsonDecode(responseBody);
                              message = decodedData['message'];
                              setState(() async {
                                SnackBar snackbar = SnackBar(
                                  content: new Text(message),
                                  backgroundColor: Colors.greenAccent,
                                );
                                setState(() {
                                  _showSpinner = false;
                                });
                                Scaffold.of(ctx).showSnackBar(snackbar);
                                await Future.delayed(Duration(seconds: 1));
                              });
                            } else {
                              message =
                                  "Posting Advertisement Was Unsuccessful";
                              setState(() async {
                                SnackBar snackbar = SnackBar(
                                  content: new Text(message),
                                  backgroundColor: Colors.redAccent,
                                );
                                setState(() {
                                  _showSpinner = false;
                                });
                                Scaffold.of(ctx).showSnackBar(snackbar);
                                await Future.delayed(Duration(seconds: 1));
                              });
                            }
                            setState(() {
                              _showSpinner = false;
                            });
                          },
                          child: ListTile(
                            dense: true,
                            title: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                            trailing: Icon(FontAwesomeIcons.paperPlane),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
