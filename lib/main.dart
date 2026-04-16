import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Screen orientation lock (optional but good)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // ✅ Stripe init
  Stripe.publishableKey =
      "pk_test_51THkYtPu93DI4wH4aLhk8RXQRYK8Fxrtd9Uu9mlIOeRkHLe12raTBAL2tn2XWhHGvt16D4hDgC5eMTDLzmm8ZmkT001WBKGA4F";
  
  // try {
  //   await Stripe.instance.applySettings();
  // } catch (e) {
  //   // Stripe init fail hone se app crash na ho
  //   print("Stripe init error: $e");
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VoxyLive',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF0E0F0B),
        // fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}