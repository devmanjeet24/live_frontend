import '../services/api.dart';

class UserService {
  static Future<void> updateProfile({
    required String username,
    String? imagePath,
  }) async {
    await Api.putMultipart(
      "/user/profile",
      {"username": username},
      imagePath,
    );
  }


  static Future<Map<String, dynamic>> getProfile() async {
    return await Api.get("/user/profile");
  }

  static Future<void> requestStreamer() async {
  await Api.post("/user/request-streamer", {});
 }

}

