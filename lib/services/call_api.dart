
// ignore_for_file: prefer_interpolation_to_compose_strings
//call_api.dart
//This file will contain various methods used to call different APIs according to the functional purposes of the App.
import 'dart:convert';
import 'package:my_trip_project/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:my_trip_project/utils/env.dart';

class CallAPI {
  //Method call check_login_api.php -----------------------------------------------

  static Future<User> callCheckLoginAPI(User user) async {
    //call to use API and then store the values received from the API in variables.
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/mt6552410011/apis/checkUserPasswordAPI.php'), // api url
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (responseData.statusCode == 200) {
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }

  //Method call register_api.php (add new user member)-----------------------------------------------

  static Future<User> callnewUserAPI(User user) async {
    //call to use API and then store the values received from the API in variables.
    final responseData = await http.post(
      Uri.parse(Env.hostName + '/mt6552410011/apis/newUserAPI.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (responseData.statusCode == 200) {
      return User.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to call API');
    }
  }
  
}
