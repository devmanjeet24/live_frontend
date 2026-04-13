import 'api.dart';

class CoinService {
  static Future<int> getBalance() async {
    final res = await Api.get("/coins/balance");
    return res["balance"] ?? 0;
  }

  // Testing ke liye seedha coins add karo
  static Future<int> addCoins(int coins) async {
    final res = await Api.post("/coins/add", {"coins": coins});
    return res["balance"] ?? 0;
  }
}