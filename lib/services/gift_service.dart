import 'api.dart';

class GiftService {
  static Future<int> sendGift({
    required String giftType,
    required String roomId,
    required String receiverUsername,
  }) async {
    final res = await Api.post("/gifts/send", {
      "giftType": giftType,
      "roomId": roomId,
      "receiverUsername": receiverUsername,
    });
    return res["newBalance"] ?? 0;
  }
}