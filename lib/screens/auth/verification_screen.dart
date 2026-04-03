import 'package:flutter/material.dart';
import 'dob_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  /// OTP controllers
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  /// 🔥 OTP Complete (UI only)
  void _onOtpComplete() {
    String otp = controllers.map((e) => e.text).join();

    if (otp.length == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DobScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    /// auto focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }

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
            /// 🔥 Title
            const Text(
              "Verification",
              style: TextStyle(
                fontFamily: "MuseoModerno",
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// 🔥 Subtitle
            const Text(
              "We sent a verification code to\n“aishwary@example.com”.",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 Info box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFFFBF7C).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline,
                      color: Color(0xFFE98834), size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Just in case check your Spam Folder.",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 OTP BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                return Container(
                  width: 75,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1B18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 3) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else {
                          _onOtpComplete();
                        }
                      } else if (index > 0) {
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                    },
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            /// 🔁 Resend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Resend Code",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    color: Color(0xFFE98834),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "in 00:30",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// 🔥 Bottom text
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 11,
                  color: Colors.white70,
                ),
                children: [
                  TextSpan(
                    text:
                        "By logging in you confirm you are above 18 years and accept our ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: Color(0xFFE98834),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Term & Condition",
                    style: TextStyle(
                      color: Color(0xFFE98834),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}