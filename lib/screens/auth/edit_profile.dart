import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:voxylive/screens/home/dashboard.dart';

class FinishSetupScreen extends StatelessWidget {
  const FinishSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            /// TITLE
            Text(
              "Make your first\nImpression truly count",
              style: const TextStyle(
                fontFamily: "MuseoModerno",
                color: Color.fromARGB(199, 255, 255, 255),
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            /// SUBTITLE
            Text(
              "Your First Impression sets the tone for everything follows",
              style: const TextStyle(
                fontFamily: "Inter",
                color: Color.fromARGB(182, 233, 136, 52),
              ),
            ),

            const SizedBox(height: 30),

            /// AVATAR LABEL
            Text.rich(
              TextSpan(
                text: "Avatar ",
                style: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white70,
                ),
                children: [
                  TextSpan(
                    text: "(Profile Pic)",
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFFE98834),
                    ),
                  ),
                ],
              ),
            ),

            // Text(
            //   "Avatar (Profile Pic)",
            //   style: GoogleFonts.Inter(color: Colors.white70),
            // ),
            const SizedBox(height: 15),

            /// AVATAR + BUTTON
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage("assets/images/avattar.png"),
                ),

                const SizedBox(width: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE98834),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  child: Text(
                    "Change Image",
                    style: const TextStyle(
                      fontFamily: "Inter",
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// USERNAME
            Text.rich(
              TextSpan(
                text: "UserName ",
                style: const TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white70,
                ),
                children: [
                  TextSpan(
                    text: "(Display Name)",
                    style: const TextStyle(
                      fontFamily: "Inter",

                      color: Color.fromARGB(175, 233, 136, 52),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "User-Ninja",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            /// INFO BOX (GRADIENT)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFFFBF7C).withOpacity(0.2),
                    const Color(0xFF99734A).withOpacity(0.0),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    color: Color(0xFFE98834),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Don’t worry you will be able to change these again",
                      style: const TextStyle(
                        fontFamily: "Inter",
                        color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// FINISH BUTTON
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: Text(
                  "Finish",
                  style: const TextStyle(
                    fontFamily: "Inter",
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// 🔥 BOTTOM SHEET (MAIN PART)
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1B18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Image",
                style: const TextStyle(
                  fontFamily: "MuseoModerno",
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  /// TAKE SELFIE
                  Expanded(
                    child: _option(
                      icon: LucideIcons.camera,
                      text: "Take Selfie",
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// GALLERY
                  Expanded(
                    child: _option(
                      icon: LucideIcons.image,
                      text: "Upload From Gallery",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _option({required IconData icon, required String text}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFE98834)),
          const SizedBox(height: 10),
          Text(
            text, 
            style: const TextStyle(
              fontFamily: "Inter",
              color: Colors.white70
              )
              ),
        ],
      ),
    );
  }
}
