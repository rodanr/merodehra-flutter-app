import 'package:geolocator/geolocator.dart';

Future<String> getGPSLocation() async {
  Position position =
      await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  String geoLocation =
      (position.latitude).toString() + "~" + (position.longitude).toString();
  return geoLocation;
}
