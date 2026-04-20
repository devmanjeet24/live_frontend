import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../services/coin_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int coinBalance = 0;
  List transactions = [];
  bool loading = true;
  bool paying = false;
  final TextEditingController customController = TextEditingController();

  final packages = [
    {
      "id": "pack_100",
      "coins": 100,
      "price": "₹99",
      "label": "Starter",
      "popular": false,
    },
    {
      "id": "pack_500",
      "coins": 500,
      "price": "₹449",
      "label": "Popular",
      "popular": true,
    },
    {
      "id": "pack_1000",
      "coins": 1000,
      "price": "₹799",
      "label": "Best Value",
      "popular": false,
    },
  ];

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

  Future<void> pay({String? packageId, int? customCoins}) async {
    try {
      setState(() => paying = true);

      final res = await CoinService.createPaymentIntent(
        packageId: packageId,
        customCoins: customCoins,
      );
      final int coinsToAdd = res["coins"] as int;

      final clientSecret = res["clientSecret"] as String;
      final paymentIntentId = res["paymentIntentId"] as String; // ✅ FIX

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "VoxyLive",
          style: ThemeMode.dark,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final newBalance = await CoinService.confirmPayment(paymentIntentId);

      setState(() {
        coinBalance = newBalance;
        paying = false;
      });

      await loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Coins added! New balance: $coinBalance"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on StripeException {
      if (mounted) setState(() => paying = false);
    } catch (e) {
      if (mounted) {
        setState(() => paying = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
      }
    }
  }

  void showCustomDialog() {
    customController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B18),
        title: const Text(
          "Custom Amount",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: customController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter coins (min 10)",
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE98834),
            ),
            onPressed: () {
              final val = int.tryParse(customController.text.trim());
              if (val == null || val < 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Minimum 10 coins")),
                );
                return;
              }
              Navigator.pop(context);
              pay(customCoins: val);
            },
            child: const Text("Pay", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "MuseoModerno",
            fontSize: 20,
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE98834)),
            )
          : RefreshIndicator(
              color: const Color(0xFFE98834),
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Wallet Card ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF5A3A1F), Color(0xFF1A0A00)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Coin Balance",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                              fontFamily: "Inter",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Color(0xFFE98834),
                                size: 38,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "$coinBalance",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "MuseoModerno",
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 6, left: 6),
                                child: Text(
                                  "coins",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "1 coin ≈ ₹1",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ── Top Up Section ──
                    const Text(
                      "Top Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Packages grid
                    Row(
                      children: packages.map((pkg) {
                        final isPopular = pkg["popular"] as bool;
                        return Expanded(
                          child: GestureDetector(
                            onTap: paying
                                ? null
                                : () => pay(packageId: pkg["id"] as String),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isPopular
                                    ? const Color(0xFF361900)
                                    : const Color(0xFF1A1B18),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isPopular
                                      ? const Color(0xFFE98834)
                                      : Colors.white10,
                                  width: isPopular ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (isPopular)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE98834),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        "Popular",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Color(0xFFE98834),
                                    size: 24,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${pkg["coins"]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    "coins",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pkg["price"] as String,
                                    style: TextStyle(
                                      color: isPopular
                                          ? const Color(0xFFE98834)
                                          : Colors.white70,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Custom amount button
                    GestureDetector(
                      onTap: paying ? null : showCustomDialog,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B18),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Color(0xFFE98834),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Custom Amount",
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (paying)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE98834),
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    // ── Transaction History ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transaction History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${transactions.length} records",
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (transactions.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1B18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: Colors.white24,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No transactions yet",
                              style: TextStyle(color: Colors.white38),
                            ),
                          ],
                        ),
                      )
                    else
                      ...transactions.map((t) {
                        final isCredit = t["type"] == "credit";
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1B18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isCredit
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCredit
                                      ? Icons.add_circle_outline
                                      : Icons.remove_circle_outline,
                                  color: isCredit ? Colors.green : Colors.red,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t["description"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _formatDate(t["createdAt"] ?? ""),
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${isCredit ? "+" : "-"}${t["amount"]} 🪙",
                                style: TextStyle(
                                  color: isCredit ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
