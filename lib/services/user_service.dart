import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManagement {
  Future<http.Response> signUp(String username, String email,
      String mobileNumber, String password) async {
    http.Response response = await http.post(
      'https://merodehra.herokuapp.com/signup',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password
      }),
    );
    return response;
  }

  Future<http.Response> login(String username, String password) async {
    http.Response response = await http.post(
      'https://merodehra.herokuapp.com/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );
    return response;
  }
}

Future<String> fetchProfilePictureUrl(userId) async {
  http.Response response = await http
      .get('https://merodehra.herokuapp.com/get-profile-picture/$userId');
  var responseBody = response.body;
  var decodedData = jsonDecode(responseBody);
  return decodedData["photo"];
}

Future<void> postProfilePictureUrl(userId, photoUrl) async {
  print("post ran");
  http.Response response = await http.post(
    'https://merodehra.herokuapp.com/upload-profile-picture',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'user_id': userId, 'photo': photoUrl}),
  );
  var responseBody = response.body;
  var decodedData = jsonDecode(responseBody);
  print(response.statusCode);
}
