import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0B08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem("assets/images/live.png", "Live", 0),
          _navItem("assets/images/discover.png", "Discover", 1),
          _navItem("assets/images/chat.png", "Chat", 2),
          _navItem("assets/images/myhub.png", "My Hub", 3),
        ],
      ),
    );
  }

  Widget _navItem(String icon, String label, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, width: 26, height: 26),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? const Color(0xFFF4A261)
                  : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}