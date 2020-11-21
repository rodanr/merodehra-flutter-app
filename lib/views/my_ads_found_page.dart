import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merodehra/componenets/list_card.dart';
import 'package:merodehra/services/advertisement_service.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'advertisement_view_page.dart';

bool _showSpinner = false; //false by default

class MyAdsFoundPage extends StatefulWidget {
  final List<dynamic> advertisementList;

  MyAdsFoundPage({this.advertisementList});

  @override
  _MyAdsFoundPageState createState() => _MyAdsFoundPageState();
}

class _MyAdsFoundPageState extends State<MyAdsFoundPage> {
  Widget buildListView() {
    return ListView.builder(
      itemCount: widget.advertisementList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return new ListCard(
          propertyType: widget.advertisementList[index]["property_type"],
          propertyPrice: widget.advertisementList[index]["price"].toString(),
          roomCount: widget.advertisementList[index]["room_count"].toString(),
          propertyAddress: widget.advertisementList[index]["property_address"],
          ownerName: widget.advertisementList[index]["username"],
          onPress: () async {
            setState(() {
              _showSpinner = true;
            });
            int advertisementId =
                widget.advertisementList[index]["advertisement_id"];
            AdvertisementManagement getSingleAdvertisement =
                new AdvertisementManagement();
            http.Response response = await getSingleAdvertisement
                .getSingleAdvertisement(advertisementId);
            if (response.statusCode == 200) {
              setState(() {
                _showSpinner = false;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AdvertisementView(
                  response: response,
                  advertisementId: advertisementId,
                  myFlag: false,
                );
              }));
            } else {
              //Some problem Occurred
              setState(() {
                _showSpinner = false;
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i<widget.advertisementList.length;i++){
    //   print(widget.advertisementList[i]["price"]);
    // }
    // Changing Status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff1A1929),
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                        SizedBox(
                          width: 30.0,
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            "You have total ${widget.advertisementList.length} ads posted",
                            style:
                                TextStyle(color: Colors.green, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: buildListView(),
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
