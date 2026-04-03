import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://10.0.2.2:8000";

  static Future sendEmail(String email) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return res;
  }

  static Future verifyOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return res;
  }
}