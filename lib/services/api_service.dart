import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService(BuildContext context) => _instance.._context = context;

  late BuildContext _context;

  ApiService._internal();

  static const String baseUrl = 'https://api.ipmediadev1.com/api';

  Future<http.Response> get(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? queryParams}) async {
    String url = baseUrl + endpoint;

    // if (queryParams != null) {
    //   String query = Uri(queryParameters: queryParams).query;
    //   url += '?' + query;
    // }
    final Map<String, String> defaultHeaders =
        await _getDefaultHeaders(headers);
    final uri = Uri.parse(url).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: defaultHeaders);
    if (response.statusCode == 401) {
      Navigator.pop(_context);
      Navigator.pushNamed(_context, '/login');
    }
    return response;
  }

  Future<http.Response> post(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    String url = baseUrl + endpoint;

    final Map<String, String> defaultHeaders =
        await _getDefaultHeaders(headers);
    final response = await http.post(Uri.parse(url),
        headers: defaultHeaders, body: jsonEncode(body));

    return response;
  }

  Future<http.Response> postWithFile(String endpoint, dynamic body,
      {Map<String, String>? headers, File? file}) async {
    String url = baseUrl + endpoint;

    final Map<String, String> defaultHeaders =
        await _getDefaultHeaders(headers);
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(defaultHeaders);

    if (body != null) {
      request.fields.addAll(body);
    }

    if (file != null) {
      final fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      final fileLength = await file.length();
      request.files.add(http.MultipartFile('file', fileStream, fileLength,
          filename: file.path.split('/').last));
    }

    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<http.Response> put(String endpoint, dynamic body,
      {Map<String, String>? headers, File? file}) async {
    String url = baseUrl + endpoint;
    final Map<String, String> defaultHeaders =
        await _getDefaultHeaders(headers);
    final request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(defaultHeaders);

    if (body != null) {
      request.fields.addAll(body);
    }

    if (file != null) {
      final fileStream = http.ByteStream(Stream.castFrom(file.openRead()));
      final fileLength = await file.length();
      request.files.add(http.MultipartFile('file', fileStream, fileLength,
          filename: file.path.split('/').last));
    }

    final response = await http.Response.fromStream(await request.send());
    return response;
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    final Map<String, String> defaultHeaders =
        await _getDefaultHeaders(headers);
    final response = await http.delete(Uri.parse(url), headers: defaultHeaders);
    return response;
  }

  Future<Map<String, String>> _getDefaultHeaders(
      Map<String, String>? headers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('access_token');
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authToken != null) {
      defaultHeaders['Authorization'] = 'Bearer $authToken';
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }
}
