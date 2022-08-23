import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kitcan_app/allMenuModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as https;

class ApiService {
  Dio dio = Dio();
  dynamic token;

  setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString("token");
    print("token: $token");
  }

  Map<String, String> _setHeaders() =>
      {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};

  Future postLoginApi(String username, String password) async {
    final response = await dio.post("http://116.202.10.98:9050/api/auth/login",
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'content-Type': 'application/json',
          },
        ));
    if (response.statusCode == 200) {
      setToken(response.data['token']['access_token']);
      return response.data;
    } else {
      throw Exception();
    }
  }

  Future<AllMenuModel?> getAllMenu() async {
    getToken();
    https.Response response = await https.get(
        Uri.parse("http://116.202.10.98:9050/api/food"),
        headers: _setHeaders());
    var data = response.body;

    if (response.statusCode == 200) {
      AllMenuModel menu = AllMenuModel.fromJson(json.decode(data));

      return menu;
    }
  }
}
