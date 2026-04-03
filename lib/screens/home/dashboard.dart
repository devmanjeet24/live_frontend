import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 TOP SECTION (header aayega yaha)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LEFT SIDE
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(
                          "assets/images/avattar.png",
                        ),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome",
                            style: const TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "User-Ninja",
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

                  /// RIGHT SIDE
                  Row(
                    children: [
                      /// COINS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A3A1F),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/coin.png",
                              height: 32,
                              width: 32,
                            ),
                            // SizedBox(width: 6),
                            Text("00", style: TextStyle(color: Colors.white)),
                            SizedBox(width: 20),
                            CircleAvatar(
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

                      const SizedBox(width: 12),

                      /// BELL
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 3, 3, 3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🧭 CATEGORY TABS (next step me)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  /// 🔥 TABS (FIXED)
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

                  /// 👈 GAP (balanced)
                  const SizedBox(width: 12),

                  /// 🌍 GLOBAL
                  Row(
                    children: const [
                      Text(
                        "Global",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // 👈 thoda small
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 18, // 👈 icon bhi small
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// 🖼 CONTENT AREA (grid next step me)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 10), // 👈 bottom space
                  itemCount: 20, // 👈 jitne chahe items
                  physics: const BouncingScrollPhysics(), // 👈 smooth scroll
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final images = [
                      "assets/images/streamer1.png",
                      "assets/images/streamer2.png",
                      "assets/images/streamer3.png",
                      "assets/images/streamer4.png",
                      "assets/images/streamer5.png",
                      "assets/images/streamer6.png",
                    ];

                    return _card(images[index % images.length]);
                  },
                ),
              ),
            ),

            /// 🔻 BOTTOM NAV (last me banayenge)
            /// 🔻 BOTTOM NAV
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0B08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem("assets/images/live.png", "Live", true),
                  _navItem("assets/images/discover.png", "Discover", false),
                  _navItem("assets/images/chat.png", "Chat", false),
                  _navItem("assets/images/myhub.png", "My Hub", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ICON
        Image.asset(
          icon,
          width: 26,
          height: 26,
          // color: isActive ? null : Colors.white54, // 👈 inactive grey
        ),

        const SizedBox(height: 6),

        /// TEXT
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? const Color(0xFFF4A261) // 🟠 active
                : Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _card(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          /// IMAGE
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),

          /// 🔹 TOP LEFT (views) ✅ FIXED
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
                  SizedBox(width: 3),
                  Text(
                    "12",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 BOTTOM INFO ✅ FULL FIX
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30), // 👈 full round
              ),
              child: Row(
                children: [
                  /// AVATAR
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage("assets/images/avattar.png"),
                  ),

                  const SizedBox(width: 8),

                  /// TEXT (🔥 MOST IMPORTANT FIX)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name of the Streamer",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "MuseoModerno",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "13.25M",
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
          color: isSelected ? const Color(0xFFF4A261) : const Color(0xFF0A0B08),
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
