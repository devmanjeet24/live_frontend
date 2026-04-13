import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class Api {
  // static const String baseUrl = "http://116.202.210.102:20355/api";
  // static const String baseUrl = String.fromEnvironment("BASE_URL");

  // flutter run --dart-define=BASE_URL=http://116.202.210.102:20355/api

  static const String baseUrl = "http://116.202.210.102:20355/api";

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
    return _handleResponse(response, url: url, body: body, method: "POST");
  }

  static Future<dynamic> put(String url, dynamic body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$url"),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _handleResponse(response, url: url, body: body, method: "PUT");
  }

  static Future<dynamic> get(String url) async {
    final response = await http.get(
      Uri.parse("$baseUrl$url"),
      headers: await _headers(),
    );
    return _handleResponse(response, url: url, method: "GET");
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
    return _handleResponse(response, url: url, method: "PUT");
  }

  static Future<dynamic> _handleResponse(
    http.Response response, {
    String? url,
    dynamic body,
    String method = "GET",
    bool isRetry = false,
  }) async {
    print("🔵 URL: $url");
    print("🟡 TOKEN: ${await Storage.getAccessToken()}");
    print("🟢 STATUS: ${response.statusCode}");
    print("🔴 BODY: ${response.body}");
    // ✅ HTML response aa raha hai toh token expire hua hai
    if (response.body.trimLeft().startsWith('<')) {
      if (!isRetry && url != null) {
        final refreshed = await _tryRefresh();
        print("REFRESH TOKEN: $refreshed");
        if (refreshed) {
          return _retryRequest(url, body, method);
        }
      }
      throw Exception("Session expired. Please login again.");
    }

    final data = jsonDecode(response.body);

    // ✅ 401 handle
    if (response.statusCode == 401 && !isRetry && url != null) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _retryRequest(url, body, method);
      }
      throw Exception("Session expired. Please login again.");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(
        data["message"] ?? data["error"] ?? "Something went wrong",
      );
    }
  }

  // ✅ Retry original request after token refresh
  static Future<dynamic> _retryRequest(
    String url,
    dynamic body,
    String method,
  ) async {
    http.Response response;

    if (method == "GET") {
      response = await http.get(
        Uri.parse("$baseUrl$url"),
        headers: await _headers(),
      );
    } else if (method == "PUT") {
      response = await http.put(
        Uri.parse("$baseUrl$url"),
        headers: await _headers(),
        body: jsonEncode(body),
      );
    } else {
      response = await http.post(
        Uri.parse("$baseUrl$url"),
        headers: await _headers(),
        body: jsonEncode(body),
      );
    }

    return _handleResponse(
      response,
      url: url,
      body: body,
      method: method,
      isRetry: true,
    );
  }

  // ✅ Refresh token se naya access token lo
  static Future<bool> _tryRefresh() async {
    try {
      final refresh = await Storage.getRefreshToken();
      if (refresh == null) return false;

      final response = await http.post(
        Uri.parse("$baseUrl/auth/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": refresh}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await Storage.saveTokens(
          data["accessToken"],
          data["refreshToken"], 
        );
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
