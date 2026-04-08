import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../utils/storage.dart';
import '../../utils/loader.dart';
import 'admin_dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final controller = TextEditingController();

  void login() async {
    final email = controller.text.trim();

    if (email.isEmpty) return;

    try {
      Loader.show(context);

      final token = await AdminService.login(email);

      await Storage.saveTokens(token, "");

      Loader.hide(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboard()),
      );
    } catch (e) {
      Loader.hide(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 100),

            const Text(
              "Admin Login",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter admin email",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}