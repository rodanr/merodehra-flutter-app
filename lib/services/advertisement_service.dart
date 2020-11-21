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
      String photoUrl,
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
        "photo": photoUrl,
        "water_source": waterSource,
        "bathroom": bathroom,
        "terrace_access": terraceAccess
      }),
    );
    return response;
  }

  Future<http.Response> searchAdvertisement(String locationToSearch) async {
    http.Response response = await http
        .get('https://merodehra.herokuapp.com/search/$locationToSearch');
    // print(response.statusCode);
    return response;
  }

  Future<http.Response> getSingleAdvertisement(int advertisementId) async {
    http.Response response = await http
        .get('https://merodehra.herokuapp.com/advertisement/$advertisementId');
    // print(response.statusCode);
    return response;
  }

  Future<http.Response> getMyAdvertisementList(int userId) async {
    http.Response response = await http
        .get('https://merodehra.herokuapp.com/advertisement/user/$userId');
    // print(response.statusCode);
    return response;
  }
}
