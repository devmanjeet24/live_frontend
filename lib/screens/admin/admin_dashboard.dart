import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../services/admin_gift_service.dart';
import '../../utils/loader.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Streamer requests
  List requests = [];
  bool requestsLoading = true;

  // Gifts
  List gifts = [];
  bool giftsLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadRequests();
    loadGifts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Streamer Requests ──
  Future<void> loadRequests() async {
    try {
      final data = await AdminService.getRequests();
      setState(() {
        requests = data;
        requestsLoading = false;
      });
    } catch (e) {
      setState(() => requestsLoading = false);
    }
  }

  Future<void> approve(String id) async {
    try {
      Loader.show(context);
      await AdminService.approve(id);
      Loader.hide(context);
      loadRequests();
    } catch (e) {
      Loader.hide(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> reject(String id) async {
    try {
      Loader.show(context);
      await AdminService.reject(id);
      Loader.hide(context);
      loadRequests();
    } catch (e) {
      Loader.hide(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ── Gifts ──
  Future<void> loadGifts() async {
    try {
      final data = await AdminGiftService.getAll();
      setState(() {
        gifts = data;
        giftsLoading = false;
      });
    } catch (e) {
      setState(() => giftsLoading = false);
    }
  }

  Future<void> toggleGift(String id) async {
    try {
      await AdminGiftService.toggle(id);
      loadGifts();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void showCreateGiftDialog() {
    final typeC = TextEditingController();
    final nameC = TextEditingController();
    final emojiC = TextEditingController();
    final costC = TextEditingController();
    final diamondsC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B18),
        title: const Text("Create Gift",
            style: TextStyle(color: Colors.white, fontFamily: "MuseoModerno")),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(typeC, "Type (e.g. rose) — unique ID"),
            _field(nameC, "Display Name (e.g. Rose)"),
            _field(emojiC, "Emoji (e.g. 🌹)"),
            _field(costC, "Coin Cost", number: true),
            _field(diamondsC, "Diamonds Earned", number: true),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE98834)),
            onPressed: () async {
              if (typeC.text.isEmpty ||
                  nameC.text.isEmpty ||
                  emojiC.text.isEmpty ||
                  costC.text.isEmpty ||
                  diamondsC.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields required")));
                return;
              }
              try {
                await AdminGiftService.create({
                  "type": typeC.text.trim(),
                  "name": nameC.text.trim(),
                  "emoji": emojiC.text.trim(),
                  "coinCost": int.parse(costC.text.trim()),
                  "diamondsEarned": int.parse(diamondsC.text.trim()),
                });
                Navigator.pop(context);
                loadGifts();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gift created!")));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: const Text("Create",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {bool number = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: c,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        elevation: 0,
        title: const Text("Admin Panel",
            style: TextStyle(
                color: Colors.white, fontFamily: "MuseoModerno")),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFE98834),
          labelColor: const Color(0xFFE98834),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "Streamer Requests"),
            Tab(text: "Gift Management"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Tab 1: Streamer Requests ──
          requestsLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFE98834)))
              : requests.isEmpty
                  ? const Center(
                      child: Text("No pending requests",
                          style: TextStyle(color: Colors.white54)))
                  : RefreshIndicator(
                      onRefresh: loadRequests,
                      color: const Color(0xFFE98834),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: requests.length,
                        itemBuilder: (_, i) {
                          final r = requests[i];
                          final user = r["user"] ?? {};
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1B18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: const Color(0xFF2A2A2A),
                                backgroundImage: user["avatar"] != null
                                    ? NetworkImage(user["avatar"])
                                    : null,
                                child: user["avatar"] == null
                                    ? const Icon(Icons.person,
                                        color: Colors.white54)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user["username"] ??
                                          user["email"] ??
                                          "Unknown",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      user["email"] ?? "",
                                      style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: r["status"] == "pending"
                                            ? Colors.orange.withOpacity(0.2)
                                            : r["status"] == "approved"
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.red.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        r["status"] ?? "",
                                        style: TextStyle(
                                          color: r["status"] == "pending"
                                              ? Colors.orange
                                              : r["status"] == "approved"
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (r["status"] == "pending")
                                Row(children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        color: Colors.green),
                                    onPressed: () => approve(r["_id"]),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel,
                                        color: Colors.red),
                                    onPressed: () => reject(r["_id"]),
                                  ),
                                ]),
                            ]),
                          );
                        },
                      ),
                    ),

          // ── Tab 2: Gift Management ──
          giftsLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFE98834)))
              : RefreshIndicator(
                  onRefresh: loadGifts,
                  color: const Color(0xFFE98834),
                  child: Column(children: [
                    // Create button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE98834),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Colors.black),
                          label: const Text("Create New Gift",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          onPressed: showCreateGiftDialog,
                        ),
                      ),
                    ),

                    gifts.isEmpty
                        ? const Center(
                            child: Text("No gifts yet",
                                style:
                                    TextStyle(color: Colors.white54)))
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              itemCount: gifts.length,
                              itemBuilder: (_, i) {
                                final g = gifts[i];
                                final isActive =
                                    g["isActive"] ?? false;
                                return Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A1B18),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isActive
                                          ? const Color(0xFFE98834)
                                              .withOpacity(0.3)
                                          : Colors.white10,
                                    ),
                                  ),
                                  child: Row(children: [
                                    Text(g["emoji"] ?? "🎁",
                                        style: const TextStyle(
                                            fontSize: 32)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(g["name"] ?? "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.w600,
                                                fontSize: 15,
                                              )),
                                          const SizedBox(height: 3),
                                          Text(
                                            "Cost: ${g["coinCost"]} 🪙  ·  Earns: ${g["diamondsEarned"]} 💎",
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            "Type: ${g["type"]}",
                                            style: const TextStyle(
                                                color: Colors.white38,
                                                fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(children: [
                                      Switch(
                                        value: isActive,
                                        activeColor:
                                            const Color(0xFFE98834),
                                        onChanged: (_) =>
                                            toggleGift(g["_id"]),
                                      ),
                                      Text(
                                        isActive ? "Active" : "Off",
                                        style: TextStyle(
                                          color: isActive
                                              ? const Color(0xFFE98834)
                                              : Colors.white38,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ]),
                                  ]),
                                );
                              },
                            ),
                          ),
                  ]),
                ),
        ],
      ),
    );
  }
}