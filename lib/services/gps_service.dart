import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<String> getGPSLocation() async {
  Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  String geoLocation =
      (position.latitude).toString() + "~" + (position.longitude).toString();
  return geoLocation;
}

Future<LatLng> getSourceLocation() async {
  print("getSourceLocation called");
  Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  LatLng sourceLocation = LatLng(position.latitude, position.longitude);
  print(sourceLocation.latitude);
  return sourceLocation;
}
