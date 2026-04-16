import 'package:flutter/material.dart';
import 'package:voxylive/services/socket_service.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  // ✅ Socket se aane wale messages yahan store honge
  List<Map<String, String>> chatMessages = [];

  @override
  void initState() {
    super.initState();

    // ✅ Global chat listener — jo bhi room mein message aaye
    SocketService.socket?.on("receive-message", (data) {
      if (mounted) {
        setState(() {
          chatMessages.add({
            "user": data["user"]?.toString() ?? "Unknown",
            "message": data["message"]?.toString() ?? "",
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // ✅ ChatTab dispose hone pe listener hata do
    // (LivePlayerScreen ka apna listener alag hai — conflict nahi hoga)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      body: chatMessages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.chat_bubble_outline,
                      color: Colors.white24, size: 48),
                  SizedBox(height: 12),
                  Text(
                    "No chats yet",
                    style: TextStyle(color: Colors.white38, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Join a live stream to see messages",
                    style: TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chatMessages.length,
              itemBuilder: (_, i) {
                final msg = chatMessages[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1B18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFF2A2A2A),
                        child: Text(
                          (msg["user"] ?? "?")[0].toUpperCase(),
                          style: const TextStyle(
                              color: Color(0xFFE98834),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg["user"] ?? "",
                              style: const TextStyle(
                                color: Color(0xFFE98834),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              msg["message"] ?? "",
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}