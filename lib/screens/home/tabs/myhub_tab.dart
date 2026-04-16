import 'package:flutter/material.dart';
import 'package:voxylive/screens/admin/admin_login_screen.dart';
import 'package:voxylive/screens/auth/edit_profile.dart';
import 'package:voxylive/services/user_service.dart';
import 'package:voxylive/services/coin_service.dart';

class MyHubTab extends StatefulWidget {
  const MyHubTab({super.key});

  @override
  State<MyHubTab> createState() => _MyHubTabState();
}

class _MyHubTabState extends State<MyHubTab> {
  String username = "";
  String? avatar;
  List transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final res = await UserService.getProfile();
      final txRes = await CoinService.getTransactions();
      setState(() {
        username = res["user"]["username"] ?? "User";
        avatar = res["user"]["avatar"];
        transactions = txRes;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE98834)))
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ User ki real image + username
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: const Color(0xFF2A2A2A),
                      backgroundImage: avatar != null
                          ? NetworkImage(avatar!) as ImageProvider
                          : const AssetImage("assets/images/avattar.png"),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Manage your account",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ✅ Edit Profile — FinishSetupScreen pe jaata hai
                _menuItem(Icons.person_outline, "Edit Profile", () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinishSetupScreen(),
                    ),
                  );
                  loadData(); // wapas aane pe reload
                }),

                // ✅ Transaction History — inline expand
                _menuItem(Icons.history, "Transaction History", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionHistoryScreen(
                        transactions: transactions,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                    label: const Text(
                      "Admin Login",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      onTap: onTap,
    );
  }
}

// ✅ Transaction History Screen — naya page
class TransactionHistoryScreen extends StatelessWidget {
  final List transactions;
  const TransactionHistoryScreen({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(color: Colors.white, fontFamily: "MuseoModerno"),
        ),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text("No transactions yet",
                  style: TextStyle(color: Colors.white38)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (_, i) {
                final t = transactions[i];
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCredit
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.add_circle : Icons.remove_circle,
                          color: isCredit ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t["description"] ?? "",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Text(
                        "${isCredit ? '+' : '-'}${t["amount"]}",
                        style: TextStyle(
                          color: isCredit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}