import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_system_2/helpers/consts.dart';

class Api {
  Future<Response> get(String endPoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    final response = await http.get(
      Uri.parse("$baseUrl$endPoint"),

      headers: {
        "Accept": "application/json",
        // "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (kDebugMode) {
      print("RESPONSE GET : $baseUrl$endPoint");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> post(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl$endPoint"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",

        // "content-type": "application/json",
      },
      body: body,
    );

    if (kDebugMode) {
      print("RESPONSE POST : $baseUrl$endPoint");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> put(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("$baseUrl$endPoint"),
      body: body,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",

        // "content-type": "application/json",
      },
    );
    if (kDebugMode) {
      print("RESPONSE PUT : $baseUrl$endPoint");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> delete(String endPoint, Map body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse("$baseUrl$endPoint"),
      body: body,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",

        // "content-type": "application/json",
      },
    );

    if (kDebugMode) {
      print("RESPONSE DELETE : $baseUrl$endPoint");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }

    return response;
  }

   Future<bool> uploadFile(File file) async {
    try{
      final uri = Uri.parse("$baseUrl/vendor/upload");
      final request = http.MultipartRequest("POST", uri);
          request.files.add(
        await http.MultipartFile.fromPath(
          'file',       
          file.path,    
        ),
      );
        final response = await request.send();
      if (response.statusCode != 200) {
         return false;
      } else {
        return true;
      } 
    }
    catch(e){
      if(kDebugMode){
        print("UPLOAD ERROR: $e");
      }
      return false;
  }
  }
}
