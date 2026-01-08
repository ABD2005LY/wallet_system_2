import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:wallet_system_2/helpers/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Api {
  // Helper method to build URL with pagination
  String _buildUrl(String endPoint, {int? page, int? perPage}) {
    String url = "$baseUrl$endPoint";
    if (page != null) {
      String separator = endPoint.contains('?') ? '&' : '?';
      url = "$url${separator}page=$page";
      if (perPage != null) {
        url = "$url&per_page=$perPage";
      }
    }
    return url;
  }

  Future<Response> get(String endPoint, {int? page, int? perPage}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    String url = _buildUrl(endPoint, page: page, perPage: perPage);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (kDebugMode) {
      print("RESPONSE GET : $url");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> post(
    String endPoint,
    Map body, {
    int? page,
    int? perPage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String url = _buildUrl(endPoint, page: page, perPage: perPage);

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        // "content-type": "application/json",
      },
      body: body,
    );

    if (kDebugMode) {
      print("RESPONSE POST : $url");
      print("RESPONSE POST BODY : $body");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> put(
    String endPoint,
    Map body, {
    int? page,
    int? perPage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String url = _buildUrl(endPoint, page: page, perPage: perPage);

    final response = await http.put(
      Uri.parse(url),
      body: body,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        // "content-type": "application/json",
      },
    );
    if (kDebugMode) {
      print("RESPONSE PUT : $url");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }
    return response;
  }

  Future<Response> delete(
    String endPoint,
    Map body, {
    int? page,
    int? perPage,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String url = _buildUrl(endPoint, page: page, perPage: perPage);

    final response = await http.delete(
      Uri.parse(url),
      body: body,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        // "content-type": "application/json",
      },
    );

    if (kDebugMode) {
      print("RESPONSE DELETE : $url");
      print("RESPONSE STATUS CODE : ${response.statusCode}");
      print("RESPONSE BODY : ${response.body}");
    }

    return response;
  }

  Future<Response> upload(File file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final uri = Uri.parse("$baseUrl/vendor/uploader");

    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: path.basename(file.path),
      ),
    );

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    if (kDebugMode) {
      print("UPLOAD: $baseUrl/vendor/uploader");
      print("FILE: ${file.path}");
    }

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();
    final response = http.Response(
      responseBody,
      streamedResponse.statusCode,
      headers: streamedResponse.headers,
    );

    if (kDebugMode) {
      print("UPLOAD STATUS: ${response.statusCode}");
      print("UPLOAD BODY: ${response.body}");
    }

    return response;
  }
}