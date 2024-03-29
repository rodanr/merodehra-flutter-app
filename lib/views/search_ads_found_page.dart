import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merodehra/componenets/list_card.dart';
import 'package:merodehra/services/advertisement_service.dart';
import 'package:http/http.dart' as http;
import 'package:merodehra/views/find_ads_page_and_homepage.dart';
import 'advertisement_view_page.dart';

class SearchAdsFoundPage extends StatefulWidget {
  final List<dynamic> advertisementList;
  final String locationToSearch;

  SearchAdsFoundPage({this.advertisementList, this.locationToSearch});

  @override
  _SearchAdsFoundPageState createState() => _SearchAdsFoundPageState();
}

class _SearchAdsFoundPageState extends State<SearchAdsFoundPage> {
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
            int advertisementId =
                widget.advertisementList[index]["advertisement_id"];
            AdvertisementManagement getSingleAdvertisement =
                new AdvertisementManagement();
            http.Response response = await getSingleAdvertisement
                .getSingleAdvertisement(advertisementId);
            if (response.statusCode == 200) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AdvertisementView(
                  response: response,
                  advertisementId: advertisementId,
                  myFlag: false,
                );
              }));
            } else {
              //Some problem Occurred
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
          body: Container(
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
                          "${widget.advertisementList.length} results found for $locationToSearch ",
                          style: TextStyle(color: Colors.green, fontSize: 20.0),
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
    );
  }
}
