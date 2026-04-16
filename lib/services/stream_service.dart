import 'api.dart';

class StreamService {
  static Future<Map<String, dynamic>> getToken(String room) async {
    final res = await Api.post("/stream/token", {
      "roomName": room,
    });

    return res;
  }

    
  static Future<List> getChatHistory(String roomId) async {
    try {
      final res = await Api.get("/stream/chat/$roomId");
      return res["messages"] ?? [];
    } catch (_) {
      return [];
    }
  }

}