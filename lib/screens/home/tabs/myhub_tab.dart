// import 'package:flutter/material.dart';

// class MyHubTab extends StatelessWidget {
//   const MyHubTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("My Hub", style: TextStyle(color: Colors.white)),
//     );
//   }
// }


import 'package:flutter/material.dart';
// import 'package:voxylive/screens/admin/admin_login.dart';
import 'package:voxylive/screens/admin/admin_login_screen.dart';

class MyHubTab extends StatelessWidget {
  const MyHubTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 👤 PROFILE SECTION
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.person, size: 35, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "My Hub",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Manage your account",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// ⚙️ OPTIONS LIST
          _menuItem(Icons.person_outline, "Edit Profile", () {}),
          _menuItem(Icons.notifications_outlined, "Notifications", () {}),
          _menuItem(Icons.history, "Watch History", () {}),
          _menuItem(Icons.settings_outlined, "Settings", () {}),

          const SizedBox(height: 20),

          const Divider(color: Colors.white24),

          const SizedBox(height: 20),

          /// 🔴 ADMIN LOGIN BUTTON
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

  /// 🔧 MENU ITEM WIDGET
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