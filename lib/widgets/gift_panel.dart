import 'package:flutter/material.dart';
import '../services/gift_service.dart';

const gifts = [
  {"type": "rose",   "emoji": "🌹", "name": "Rose",   "cost": 10},
  {"type": "fire",   "emoji": "🔥", "name": "Fire",   "cost": 50},
  {"type": "crown",  "emoji": "👑", "name": "Crown",  "cost": 200},
  {"type": "rocket", "emoji": "🚀", "name": "Rocket", "cost": 500},
];

class GiftPanel extends StatelessWidget {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Send Gift 🎁",
                style: TextStyle(color: Colors.white, fontSize: 18,
                    fontWeight: FontWeight.w600)),
              Row(children: [
                const Icon(Icons.monetization_on, color: Color(0xFFE98834), size: 18),
                const SizedBox(width: 4),
                Text("$coinBalance",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: gifts.map((g) {
              return GestureDetector(
                onTap: () async {
                  if (coinBalance < (g["cost"] as int)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Insufficient coins!")),
                    );
                    return;
                  }
                  try {
                    final newBalance = await GiftService.sendGift(
                      giftType: g["type"] as String,
                      roomId: roomId,
                      receiverUsername: streamerUsername,
                    );
                    onGiftSent(newBalance);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: Column(
                  children: [
                    Text(g["emoji"] as String, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Text(g["name"] as String,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.monetization_on,
                        color: Color(0xFFE98834), size: 12),
                      Text(" ${g["cost"]}",
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ]),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}