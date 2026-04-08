import 'package:flutter/material.dart';
import 'package:voxylive/screens/live/live_player_screen.dart';

class StartStreamScreen extends StatelessWidget {
  const StartStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        title: const Text("Go Live"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Start your Live Stream",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE98834),
                ),
                onPressed: () async {
                  try {
                    // final roomName =
                    //     "room_${DateTime.now().millisecondsSinceEpoch}";

                    final roomName = "global_room";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LivePlayerScreen(room: roomName),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Failed to start")));
                  }
                },
                child: const Text("Start Live"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
