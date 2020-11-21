import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeparateLatAndLong {
  int i, j;
  String mixedText,
      temp = "";
  LatLng geoLocation;
  double lat, long;

  LatLng separateLatAndLong(rawText) {
    mixedText = rawText;
    for (i = 0; mixedText[i] != "~"; i++) {
      temp = temp + mixedText[i];
    }
    lat = double.parse(temp);
    temp = "";
    i = i +1;
    for (j = i; j<mixedText.length; j++) {
      temp = temp + mixedText[j];
    }
    long = double.parse(temp);
    geoLocation = LatLng(lat, long);
    return geoLocation;
  }
}