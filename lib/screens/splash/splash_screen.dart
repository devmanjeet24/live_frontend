import 'package:flutter/material.dart';
import 'package:voxylive/screens/home/dashboard.dart';
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
    checkLogin(); // ✅ yaha call
  }

  // ✅ YEH FUNCTION YAHA LIKHNA HAI
  Future<void> checkLogin() async {
    final token = await Storage.getAccessToken(); // ✅ important

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
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
        child: Text(
          'VoxyLive',
          style: const TextStyle(
            fontFamily: "MuseoModerno",
            color: Colors.orange,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
