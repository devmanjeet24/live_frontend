import 'package:flutter/material.dart';
import '../services/gift_service.dart';

class GiftPanel extends StatefulWidget {
  final String roomId;
  final String streamerUsername;
  final int coinBalance;
  final Function(int newBalance) onGiftSent;

  const GiftPanel({
    super.key,
    required this.roomId,
    required this.streamerUsername,
    required this.coinBalance,
    required this.onGiftSent,
  });

  @override
  State<GiftPanel> createState() => _GiftPanelState();
}

class _GiftPanelState extends State<GiftPanel> {
  List gifts = [];
  bool loading = true;
  late int _localBalance;

  @override
  void initState() {
    super.initState();
    _localBalance = widget.coinBalance;
    loadGifts();
  }

  Future<void> loadGifts() async {
    try {
      final res = await GiftService.getGiftConfigs();
      setState(() {
        gifts = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1B18),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Send a Gift 🎁",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Color(0xFFE98834),
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$_localBalance",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Gifts grid
          if (loading)
            const CircularProgressIndicator(color: Color(0xFFE98834))
          else if (gifts.isEmpty)
            const Text(
              "No gifts available",
              style: TextStyle(color: Colors.white38),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: gifts.length,
              itemBuilder: (_, i) {
                final g = gifts[i];
                final cost = g["coinCost"] as int;
                final canAfford = _localBalance >= cost;

                return GestureDetector(
                  onTap: () async {
                    if (!canAfford) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Insufficient coins!")),
                      );
                      return;
                    }
                    try {
                      final newBalance = await GiftService.sendGift(
                        giftType: g["type"],
                        roomId: widget.roomId,
                        receiverUsername: widget.streamerUsername,
                      );

                      setState(() => _localBalance = newBalance);

                      widget.onGiftSent(newBalance);

                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: Opacity(
                    opacity: canAfford ? 1.0 : 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            g["emoji"] ?? "🎁",
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            g["name"] ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Color(0xFFE98834),
                                size: 10,
                              ),
                              Text(
                                " $cost",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
