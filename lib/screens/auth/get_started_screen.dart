import 'package:flutter/material.dart';
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

          /// 🔥 Dark overlay
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
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "Where world\n",
                        style: TextStyle(
                          fontFamily: "MuseoModerno",
                          fontSize: 32,
                          height: 1.8,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "feels ",
                        style: TextStyle(
                          fontFamily: "MuseoModerno",
                          fontSize: 54,
                          height: 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "Alive",
                        style: TextStyle(
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

                /// 🔥 Buttons Row
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
                            children: const [
                              Text(
                                "Get Started",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
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

                    /// Google Button (NO FUNCTIONALITY)
                    Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD2AB),
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

                /// 🔥 Bottom Text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE98834).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          height: 6,
                          width: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE98834),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Proceeding from this screen confirms that you accept our Privacy Policy, Terms & Conditions and Terms of Use",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 11,
                          color: Color(0xFF815F42),
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