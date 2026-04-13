import 'package:flutter/material.dart';
import 'package:voxylive/screens/home/dashboard.dart';
import '../../services/auth_service.dart';
import '../../utils/loader.dart';
import 'package:flutter/services.dart';
import 'dob_screen.dart';
import 'dart:async';

class VerificationScreen extends StatefulWidget {
  final String email;
  final bool isNewUser;
  const VerificationScreen({
    super.key,
    required this.email,
    required this.isNewUser,
  });
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int seconds = 30;
  bool canResend = false;
  bool isLoading = false;
  Timer? timer;

  /// OTP controllers
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  Future<void> _checkClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? "";

    if (text.length == 4 && RegExp(r'^\d{4}$').hasMatch(text)) {
      for (int i = 0; i < 4; i++) {
        controllers[i].text = text[i];
      }
      FocusScope.of(context).unfocus();
      _onOtpComplete();
    }
  }

  void startTimer() {
    seconds = 30;
    canResend = false;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        setState(() => canResend = true);
      } else {
        setState(() => seconds--);
      }
    });
  }

  /// 🔥 OTP Complete (UI only)
  void _onOtpComplete() async {
    String otp = controllers.map((e) => e.text).join();

    if (otp.length == 4) {
      try {
        Loader.show(context);
        await AuthService.verifyOtp(widget.email, otp);
        Loader.hide(context);

        if (!mounted) return;

        // ✅ isNewUser ke basis pe route
        if (widget.isNewUser) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const DobScreen()),
          // );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DobScreen()),
            (route) => false,
          );
        } else {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const HomeScreen()),
          // );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                initialUsername: widget.email, // ya jo username hai
              ),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        Loader.hide(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    }
  }

  Future<void> _resendOtp() async {
    try {
      Loader.show(context);

      await AuthService.resendOtp(widget.email);

      Loader.hide(context);

      startTimer();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP sent again")));
    } catch (e) {
      Loader.hide(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();

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
            Text(
              "We sent a verification code to\n\"${widget.email}\".",
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
                  Icon(Icons.info_outline, color: Color(0xFFE98834), size: 18),
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
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onTap: () {
                      // ✅ Clipboard check karo jab box tap ho
                      _checkClipboard();
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        if (index > 0) {
                          controllers[index - 1].clear();
                          FocusScope.of(
                            context,
                          ).requestFocus(focusNodes[index - 1]);
                        }
                        return;
                      }
                      if (index < 3) {
                        FocusScope.of(
                          context,
                        ).requestFocus(focusNodes[index + 1]);
                      } else {
                        FocusScope.of(context).unfocus();
                        _onOtpComplete();
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
              children: [
                GestureDetector(
                  onTap: canResend ? _resendOtp : null,
                  child: Text(
                    canResend
                        ? "Resend Code"
                        : "Resend in 00:${seconds.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: canResend ? const Color(0xFFE98834) : Colors.grey,
                    ),
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

  @override
  void dispose() {
    timer?.cancel();

    for (var c in controllers) {
      c.dispose();
    }

    for (var f in focusNodes) {
      f.dispose();
    }

    super.dispose();
  }
}
