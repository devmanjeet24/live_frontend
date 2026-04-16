import 'package:flutter/material.dart';
import 'package:voxylive/screens/admin/admin_dashboard.dart';
import 'package:voxylive/screens/coins/wallet_screen.dart';
import 'package:voxylive/screens/home/tabs/chat_tab.dart';
import 'package:voxylive/screens/home/tabs/discover_tab.dart';
import 'package:voxylive/screens/home/tabs/live_tab.dart';
import 'package:voxylive/screens/home/tabs/myhub_tab.dart';
import 'package:voxylive/services/coin_service.dart';
import 'package:voxylive/services/user_service.dart';
import 'package:voxylive/utils/storage.dart';
import 'package:voxylive/widgets/app_header.dart';
import 'package:voxylive/widgets/bottom_nav.dart';
import 'package:voxylive/widgets/category_tabs.dart';
import 'package:voxylive/widgets/streamer_card.dart';

class HomeScreen extends StatefulWidget {
  final String? initialUsername;
  final String? initialAvatar;

  const HomeScreen({super.key, this.initialUsername, this.initialAvatar});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int selectedTab = 0;

  String username = "";
  String? avatar;
  bool loading = true;
  String role = "user";
  int coinBalance = 0;

  int currentIndex = 0;

  List<Widget> get screens => [
    LiveTab(username: username),
    DiscoverTab(username: username),
    const ChatTab(),
    const MyHubTab(),
  ];

  void initState() {
    super.initState();

    if (widget.initialUsername != null) {
      username = widget.initialUsername!;
      avatar = widget.initialAvatar;
      loading = false;
    } else {
      loadProfile(); // normal flow
    }
  }

  Future<void> loadProfile() async {
    try {
      final res = await UserService.getProfile();
      final coinRes = await CoinService.getBalance();
      // print("PROFILE RES: $res");
      print("✅ AVATAR: ${res["user"]["avatar"]}");

      setState(() {
        username = res["user"]["username"] ?? "User";
        avatar = res["user"]["avatar"];
        role = res["user"]["role"] ?? "user";
        coinBalance = coinRes;
        loading = false;
      });
    } catch (e) {
      print("PROFILE ERROR: $e");
      setState(() => loading = false);
      // print(e);
    }
  }

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
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : // AppHeader ke upar ek refresh callback add karo
                    // dashboard.dart mein build() mein AppHeader wali jagah:
                    AppHeader(
                      username: username,
                      avatar: avatar,
                      role: role,
                      coinBalance: coinBalance,
                      onWalletTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WalletScreen(),
                          ),
                        );
                        // ✅ Wapas aane ke baad balance reload karo
                        final newBalance = await CoinService.getBalance();
                        if (mounted) setState(() => coinBalance = newBalance);
                      },
                    ),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 20),

            /// 🧭 CATEGORY TABS (next step me)
            // const CategoryTabs(),

            // const SizedBox(height: 20),

            /// 🖼 CONTENT AREA (grid next step me)
            // ✅ ADD
            Expanded(child: screens[currentIndex]),

            /// 🔻 BOTTOM NAV (last me banayenge)
            /// 🔻 BOTTOM NAV
            // ✅ ADD
            BottomNav(
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
