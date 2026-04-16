import 'api.dart';

class AdminService {
  static Future<String> login(String email, String password) async {
    final res = await Api.post("/admin/login", {
      "email": email,
      "password": password,
    });
    return res["accessToken"];
  }

  static Future<List<dynamic>> getRequests() async {
    final res = await Api.get("/admin/requests");
    return res["data"];
  }

  static Future<void> approve(String id) async {
    await Api.put("/admin/approve/$id", {});
  }

  static Future<void> reject(String id) async {
    await Api.put("/admin/reject/$id", {});
  }
}
