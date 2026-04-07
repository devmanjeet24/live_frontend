import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  const CategoryTabs({super.key});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int selectedTab = 0;  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tab("For you", 0),
                  const SizedBox(width: 6),
                  _tab("Trending", 1),
                  const SizedBox(width: 6),
                  _tab("Most View", 2),
                  const SizedBox(width: 6),
                  _tab("Nearby", 3),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: const [
              Text("Global",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down,
                  color: Colors.white, size: 18),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(String text, int index) {
    final isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF4A261)
              : const Color(0xFF0A0B08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}