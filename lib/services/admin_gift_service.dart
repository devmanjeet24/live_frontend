
import 'api.dart';

class AdminGiftService {
  // Admin wale routes use karo — /admin/gifts
  static Future<List> getAll() async {
    final res = await Api.get("/admin/gifts");
    return res["gifts"] ?? [];
  }

  static Future<void> create(Map body) async {
    await Api.post("/admin/gifts", body);
  }

  static Future<void> toggle(String id) async {
    await Api.put("/admin/gifts/$id/toggle", {});
  }
}