import 'api.dart';

class CoinService {
  static Future<int> getBalance() async {
    final res = await Api.get("/coins/balance");
    return res["balance"] ?? 0;
  }

  static Future<int> addCoins(int coins) async {
    final res = await Api.post("/coins/add", {"coins": coins});
    return res["balance"] ?? 0;
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    String? packageId,
    int? customCoins,
  }) async {
    final body = packageId != null
        ? {"packageId": packageId}
        : {"customCoins": customCoins};
    return await Api.post("/coins/buy", body);
  }

  static Future<int> confirmPayment(String paymentIntentId) async {
    final res = await Api.post("/coins/confirm", {
      "paymentIntentId": paymentIntentId,
    });
    return res["balance"] ?? 0;
  }

  static Future<List> getTransactions() async {
    try {
      final res = await Api.get("/coins/transactions");
      return res["transactions"] ?? [];
    } catch (_) {
      return [];
    }
  }
}
