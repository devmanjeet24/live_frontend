import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access", access);
    await prefs.setString("refresh", refresh);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access");
  }
}