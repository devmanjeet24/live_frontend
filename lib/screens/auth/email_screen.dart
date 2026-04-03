import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxylive/screens/auth/verification_screen.dart';
import 'package:voxylive/services/api.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Get Started",
          style: const TextStyle(fontFamily: "Inter", color: Colors.white, fontSize: 16),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Title
            Text(
              "Starting with Email",
              style: const TextStyle(
                fontFamily: "MuseoModerno",
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// ✉️ Subtitle (NEW)
            Text(
              "Enter your Email to continue",
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 14, 
                color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// 📩 Input Field
            TextField(
              style: const TextStyle(
                fontFamily: "Inter",
                color: Colors.white),
              decoration: InputDecoration(
                hintText: "aishwary@example.com",
                hintStyle: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1A1B18),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Spacer(),

            /// 🔘 Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE98834),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await Api.emailAuth(emailController.text);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VerificationScreen(email: emailController.text),
                    ),
                  );
                },
                child: Text(
                  "Continue",
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
