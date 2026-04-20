import 'package:flutter/material.dart';
import 'package:voxylive/screens/coins/wallet_screen.dart';
import 'package:voxylive/screens/profile/profile_screen.dart';

class AppHeader extends StatelessWidget {
  final String username;
  final String? avatar;
  final String role;
  final int coinBalance;
  final VoidCallback? onWalletTap;

  final VoidCallback? onWalletReturn;

  const AppHeader({
    super.key,
    required this.username,
    this.avatar,
    required this.role,
    required this.coinBalance,
    this.onWalletReturn,
    this.onWalletTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        username: username,
                        avatar: avatar,
                        role: role,
                      ),
                    ),
                  );

                  if (result == true && onWalletReturn != null) {
                    onWalletReturn!();
                  }
                },
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF1A1B18),
                  child: ClipOval(
                    child: avatar != null
                        ? Image.network(
                            avatar!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              "assets/images/avattar.png",
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            "assets/images/avattar.png",
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    username.isNotEmpty ? username : "User",
                    style: const TextStyle(
                      fontFamily: "MuseoModerno",
                      color: Color(0xFFE98834),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ✅ Coin click → Wallet (UPDATED)
            GestureDetector(
              onTap:
                  onWalletTap ??
                  () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WalletScreen()),
                    );

                    if (result == true) {
                      onWalletReturn?.call();
                    }
                  },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A3A1F),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/images/coin.png",
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$coinBalance",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: Color(0xFFE98834),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 3, 3, 3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
