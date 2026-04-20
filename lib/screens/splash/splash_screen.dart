import 'package:flutter/material.dart';
import 'package:voxylive/screens/home/dashboard.dart';
import 'package:voxylive/services/user_service.dart';
import '../auth/get_started_screen.dart';
import 'package:voxylive/utils/storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // ✅ Pehle splash dikhne do
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = await Storage.getAccessToken();

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
      return;
    }

    // ✅ Token hai toh profile verify karo
    try {
      await UserService.getProfile();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      // Token invalid/expired
      await Storage.clearTokens();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Simple text — koi image nahi jo load fail ho
            const Text(
              'VoxyLive',
              style: TextStyle(
                fontFamily: "MuseoModerno",
                color: Color(0xFFE98834),
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFFE98834),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}