import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String apiUrl ='http://192.168.43.70:8000/api';

  Future<void> storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_token', token);
  }

  Future<String?> retrieveAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_token');
  }

  Future<http.Response> postRegisterData(
      {required String route, required Map<String, String> data}) async {
    String fullUrl = apiUrl + route;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _header());
  }

  Future<http.Response> postLoginData(
      {required String route, required Map<String, String> data}) async {
    final token = await retrieveAuthToken();
    final headers = _header();
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    String fullUrl = apiUrl + route;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: headers);
  }

  Future<http.Response> getUserDetails() async {
    final token = await retrieveAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(
      Uri.parse('$apiUrl/auth/getProfile'), // Update with your actual endpoint
      headers: headers,
    );

    return response;
  }

  Future<http.Response> logoutData({
    required String route,
  }) async {
    final token = await retrieveAuthToken();
    final headers = _header();
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    String fullUrl = apiUrl + route;
    return await http.post(Uri.parse(fullUrl), headers: headers);
  }

  Future<http.Response> postToCartData(
      {required String route, required Map<String, String> data}) async {
    final token = await retrieveAuthToken();
    final headers = _header();
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    String fullUrl = apiUrl + route;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: headers);
  }

  Future<http.Response> getMyCart({required String route}) async {
    final token = await retrieveAuthToken();
    final headers = _header();
    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }
    String fullUrl = apiUrl + route;
    return await http.get(Uri.parse(fullUrl), headers: headers);
  }

  _header() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
