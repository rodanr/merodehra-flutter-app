import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertisementManagement {
  Future<http.Response> postAdvertisement(
      String propertyType,
      String propertyAddress,
      String geoLocation,
      String roomCount,
      double price,
      propertyDescription,
      String waterSource,
      String bathroom,
      bool terraceAccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response = await http.post(
      'https://merodehra.herokuapp.com/advertisement',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "user_id": prefs.getInt('user_id'),
        "property_type": propertyType,
        "property_address": propertyAddress,
        "geo_location": geoLocation,
        "room_count": roomCount,
        "price": price,
        "description": propertyDescription,
        "water_source": waterSource,
        "bathroom": bathroom,
        "terrace_access": terraceAccess
      }),
    );
    return response;
  }
}