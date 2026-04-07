import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/loader.dart';
import 'verification_screen.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Get Started",
          style: TextStyle(
            fontFamily: "Inter",
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Starting with Email",
              style: TextStyle(
                fontFamily: "MuseoModerno",
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Enter your Email to continue",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            /// Input (no controller)
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "aishwary@example.com",
                hintStyle: const TextStyle(color: Colors.grey),
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

            /// Button (simple navigation)
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
                  final email = emailController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter email")),
                    );
                    return;
                  }

                  try {
                    Loader.show(context);

                    final isNewUser = await AuthService.emailAuth(
                      email,
                    ); // 👈 bool lo

                    Loader.hide(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VerificationScreen(
                          email: email,
                          isNewUser: isNewUser, // 👈 pass karo
                        ),
                      ),
                    );
                  } catch (e) {
                    Loader.hide(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
