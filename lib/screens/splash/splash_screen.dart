import 'package:flutter/material.dart';
import '../auth/get_started_screen.dart';
import '../../utils/storage.dart'; // 👈 add karo
import '../home/dashboard.dart'; // 👈 add karo

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedScreen()),
      );
    });
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
