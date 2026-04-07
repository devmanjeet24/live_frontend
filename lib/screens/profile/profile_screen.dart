import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../auth/get_started_screen.dart';
import '../auth/edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String username;
  final String? avatar;

  const ProfileScreen({super.key, required this.username, this.avatar});

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
                child: avatar != null
                    ? Image.network(
                        avatar!,
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
              username,
              style: const TextStyle(
                fontFamily: "MuseoModerno",
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FinishSetupScreen(),
                    ),
                  );
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
