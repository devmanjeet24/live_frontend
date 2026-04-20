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

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("refresh");
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access");
    await prefs.remove("refresh");
  }

  static Future<void> set(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  static Future<dynamic> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}
