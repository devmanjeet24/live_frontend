import 'package:flutter/material.dart';
import 'package:voxylive/services/socket_service.dart';
import 'package:voxylive/services/user_service.dart';
import 'package:voxylive/services/stream_service.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<Map<String, String>> chatMessages = [];
  List allStreamers = [];
  String? selectedRoomId;
  String? selectedStreamerName;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadStreamers();

    // ✅ Live messages bhi capture karo
    SocketService.socket?.on("receive-message", (data) {
      if (mounted && selectedRoomId != null) {
        setState(() {
          chatMessages.add({
            "user": data["user"]?.toString() ?? "Unknown",
            "message": data["message"]?.toString() ?? "",
          });
        });
      }
    });
  }

  Future<void> loadStreamers() async {
    try {
      final res = await UserService.getAllStreamers();
      setState(() => allStreamers = res);
    } catch (_) {}
  }

  Future<void> loadChatHistory(String roomId, String streamerName) async {
    setState(() {
      loading = true;
      selectedRoomId = roomId;
      selectedStreamerName = streamerName;
      chatMessages = [];
    });
    try {
      final history = await StreamService.getChatHistory(roomId);
      setState(() {
        chatMessages = history.map<Map<String, String>>((m) => {
          "user": m["user"]?.toString() ?? "Unknown",
          "message": m["message"]?.toString() ?? "",
        }).toList();
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Streamer select nahi kiya — list dikhao
    if (selectedRoomId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0E0F0B),
        body: allStreamers.isEmpty
            ? const Center(
                child: Text("No streamers found",
                    style: TextStyle(color: Colors.white38)),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Text(
                      "Chat History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "MuseoModerno",
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: allStreamers.length,
                      itemBuilder: (_, i) {
                        final s = allStreamers[i];
                        final username = s["username"] ?? "Unknown";
                        // roomId = streamer ka username (LiveKit room name)
                        final roomId = username;
                        return GestureDetector(
                          onTap: () => loadChatHistory(roomId, username),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1B18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  backgroundImage: s["avatar"] != null
                                      ? NetworkImage(s["avatar"])
                                      : null,
                                  child: s["avatar"] == null
                                      ? Text(
                                          username[0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFFE98834),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Color(0xFFE98834)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      );
    }

    // ✅ Streamer select kiya — chat history dikhao
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE98834)),
          onPressed: () => setState(() {
            selectedRoomId = null;
            selectedStreamerName = null;
            chatMessages = [];
          }),
        ),
        title: Text(
          selectedStreamerName ?? "Chat",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "MuseoModerno",
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE98834)))
          : chatMessages.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Colors.white24, size: 48),
                      SizedBox(height: 12),
                      Text("No messages yet",
                          style: TextStyle(
                              color: Colors.white38, fontSize: 16)),
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
                                fontSize: 12,
                              ),
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