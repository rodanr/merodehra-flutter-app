import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListCard extends StatelessWidget {
  final String propertyType, propertyPrice, roomCount, propertyAddress, ownerName;
  final Function onPress;

  ListCard(
      {@required this.propertyType,
      @required this.propertyPrice,
      @required this.roomCount,
      @required this.propertyAddress,
      this.ownerName,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        color: Color(0xff2D1D40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.home_filled,
                color: Colors.blue,
              ),
              title: Text(
                propertyType == "Room"
                    ? "$roomCount rooms in $propertyAddress"
                    : "Flat with $roomCount in $propertyAddress",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Price: Nrs" + propertyPrice,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70.0, 0.0, 0, 5.0),
              child: Text(
                "Posted By: $ownerName",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
