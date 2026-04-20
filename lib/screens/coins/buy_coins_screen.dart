import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../services/coin_service.dart';

const packages = [
  {"id": "pack_100", "coins": 100, "price": "₹99", "label": "Starter"},
  {"id": "pack_500", "coins": 500, "price": "₹449", "label": "Popular"},
  {"id": "pack_1000", "coins": 1000, "price": "₹799", "label": "Best Value"},
];

class BuyCoinsScreen extends StatefulWidget {
  const BuyCoinsScreen({super.key});
  @override
  State<BuyCoinsScreen> createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreen> {
  int coinBalance = 0;
  List transactions = [];
  bool loading = true;
  bool paying = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final balance = await CoinService.getBalance();
      final history = await CoinService.getTransactions();
      setState(() {
        coinBalance = balance;
        transactions = history;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  // Future<void> buyCoins(String packageId) async {
  Future<void> pay({String? packageId, int? customCoins}) async {
    try {
      setState(() => paying = true);

      // Backend se payment intent lo
      final res = await CoinService.createPaymentIntent(packageId: packageId);
      final clientSecret = res["clientSecret"];

      // Stripe payment sheet initialize karo
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "VoxyLive",
          style: ThemeMode.dark,
        ),
      );

      // Payment sheet open karo
      await Stripe.instance.presentPaymentSheet();

      // ✅ backend confirm call (IMPORTANT FIX)
      // final clientSecret = res["clientSecret"] as String;
      // final paymentIntentId = clientSecret.split("_secret_")[0];
      final paymentIntentId = res["paymentIntentId"];

      await CoinService.confirmPayment(paymentIntentId);

      // UI update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Coins added successfully!")),
      );

      await loadData(); // balance reload
    } catch (e) {
      if (e is StripeException) {
        // User ne cancel kiya — ignore
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
      }
    } finally {
      setState(() => paying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontFamily: "MuseoModerno"),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE98834)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5A3A1F), Color(0xFF361900)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Coin Balance",
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Color(0xFFE98834),
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$coinBalance",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: "MuseoModerno",
                              ),
                            ),
                            const Text(
                              " coins",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Buy Coins",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // temporaray button to add coins in wallet
                  const SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      await CoinService.addCoins(500);
                      await loadData();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ 500 test coins added!"),
                        ),
                      );
                    },
                    child: const Text(
                      "Add 500 Test Coins",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Packages
                  ...packages.map(
                    (pkg) => GestureDetector(
                      // onTap: paying ? null : () => buyCoins(pkg["id"] as String),
                      onTap: paying
                          ? null
                          : () => pay(packageId: pkg["id"] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Color(0xFFE98834),
                              size: 28,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${pkg["coins"]} Coins",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    pkg["label"] as String,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE98834),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                pkg["price"] as String,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Transaction History
                  const Text(
                    "Transaction History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (transactions.isEmpty)
                    const Text(
                      "No transactions yet",
                      style: TextStyle(color: Colors.white38),
                    )
                  else
                    ...transactions.map(
                      (t) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              t["type"] == "credit"
                                  ? Icons.add_circle
                                  : Icons.remove_circle,
                              color: t["type"] == "credit"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                t["description"] ?? "",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                            Text(
                              "${t["type"] == "credit" ? "+" : "-"}${t["amount"]}",
                              style: TextStyle(
                                color: t["type"] == "credit"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
