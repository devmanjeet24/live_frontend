import 'package:flutter/material.dart';
import 'package:voxylive/screens/live/start_stream_screen.dart';
import 'package:voxylive/services/user_service.dart';
import '../../utils/storage.dart';
import '../auth/get_started_screen.dart';
import '../auth/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String? avatar;
  final String role;

  const ProfileScreen({
    super.key,
    required this.username,
    this.avatar,
    this.role = "user",
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool requestSent = false;
  @override
  void initState() {
    super.initState();
    _checkPendingRequest();
  }

  Future<void> _checkPendingRequest() async {
    try {
      final pending = await Storage.get("streamer_requested");
      if (pending == "true") {
        setState(() => requestSent = true);
      }
    } catch (_) {}
  }

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
          "Profile",
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
          children: [
            const SizedBox(height: 40),

            /// AVATAR
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF1A1B18),
              child: ClipOval(
                child: widget.avatar != null
                    ? Image.network(
                        widget.avatar!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/avattar.png",
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/avattar.png",
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// USERNAME
            Text(
              widget.username,
              style: const TextStyle(
                fontFamily: "MuseoModerno",
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            if (widget.role == "streamer")
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: const Text(
                  "🔴 Streamer",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            const SizedBox(height: 60),

            /// EDIT PROFILE BUTTON
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinishSetupScreen(),
                    ),
                  );

                  // ✅ Agar update hua
                  if (result == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Go Live Button
            if (widget.role == "streamer")
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StartStreamScreen(username: widget.username),
                      ),
                    );
                  },
                  child: const Text(
                    "GO LIVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            /// 🔥 BECOME STREAMER — sirf tab dikhao jab streamer nahi hai
            if (widget.role != "streamer")
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: requestSent
                        ? const Color(0xFF3A2713)
                        : const Color(0xFFE98834),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: requestSent
                      ? null
                      : () async {
                          try {
                            await UserService.requestStreamer();

                            // ✅ save in storage
                            await Storage.set("streamer_requested", "true");

                            setState(() => requestSent = true);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Request sent! Pending admin approval",
                                ),
                              ),
                            );
                          } catch (e) {
                            setState(() => requestSent = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                  child: Text(
                    requestSent ? "⏳ Request Pending..." : "Become a Streamer",
                    style: TextStyle(
                      color: requestSent ? Colors.white38 : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 60),

            /// LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await Storage.clearTokens();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const GetStartedScreen()),
                    (route) => false, // sab screens hata do
                  );
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
