import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'email_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔥 Background Image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/get_started_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔥 Dark overlay (for text visibility)
          Container(color: Colors.black.withOpacity(0.4)),

          /// 🔥 Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                /// 🔥 Main Text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Where world\n",
                        style: const TextStyle(
                          fontFamily: "MuseoModerno",
                          fontSize: 32,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "feels ",
                        style: const TextStyle(
                          fontFamily: "MuseoModerno",
                          fontSize: 54,
                          height: 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "Alive",
                        style: const TextStyle(
                          fontFamily: "MuseoModerno",
                          fontSize: 54,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE98834),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// 🔥 Button Row
                Row(
                  children: [
                    /// Get Started Button
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE98834),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EmailScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Get Started",
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Google Button (circle)
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD2AB),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/Google.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// 🔥 Bottom Text (NO navigation)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFE98834,
                        ).withOpacity(0.2), // 🔥 outer light bg
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE98834), // 🔥 inner solid dot
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 11,
                            color: Color(0xFF815F42),
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "Proceeding from this screen confirms that you accept our ",
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                color: Color(0xFFE98834),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ", "),
                            TextSpan(
                              text: "Terms & Conditions",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                color: Color(0xFFE98834),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: " and "),
                            TextSpan(
                              text: "Terms of Use",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                color: Color(0xFFE98834),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
