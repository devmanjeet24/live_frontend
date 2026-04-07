import 'package:flutter/material.dart';
import 'package:voxylive/screens/profile/profile_screen.dart'; // 👈 add karo

class AppHeader extends StatelessWidget {
  final String username;
  final String? avatar;

  const AppHeader({super.key, required this.username, this.avatar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              // 👇 GestureDetector wrap karo
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfileScreen(username: username, avatar: avatar),
                    ),
                  );
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
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/images/avattar.png",
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              );
                            },
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

        /// RIGHT SIDE
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF5A3A1F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/coin.png", height: 28, width: 28),
                  const Text("00", style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, size: 16, color: Color(0xFFE98834)),
                  ),
                ],
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
