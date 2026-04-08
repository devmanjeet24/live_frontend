import 'api.dart';

class StreamService {
  static Future<Map<String, dynamic>> getToken(String room) async {
    final res = await Api.post("/stream/token", {
      "roomName": room,
    });

    return res;
  }
}