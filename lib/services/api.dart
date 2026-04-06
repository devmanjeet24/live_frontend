import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class Api {
  // static const String baseUrl = "http://10.0.2.2:8000/api";
  static const String baseUrl = "https://voxyliv-backend.onrender.com/api";
  

  static Future<Map<String, String>> _headers() async {
    final token = await Storage.getAccessToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<dynamic> post(String url, dynamic body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$url"),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> putMultipart(
    String url,
    Map<String, String> fields,
    String? filePath,
  ) async {
    var request = http.MultipartRequest("PUT", Uri.parse("$baseUrl$url"));

    request.headers.addAll(await _headers());
    request.fields.addAll(fields);

    if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath("avatar", filePath));
    }

    var res = await request.send();
    var response = await http.Response.fromStream(res);

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) async {
    final data = jsonDecode(response.body);

    // if (response.statusCode == 401) {
    //   // 🔥 auto refresh logic
    //   final newToken = await _refreshToken();

    //   if (newToken != null) {
    //     throw Exception("retry"); // frontend retry karega
    //   }
    // }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      // throw Exception(data["message"] ?? "Error");
      throw Exception(data["message"] ?? data["error"] ?? "Something went wrong");
    }
  }
}
