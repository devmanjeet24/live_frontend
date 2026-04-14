import 'package:flutter/material.dart';
import 'package:voxylive/services/socket_service.dart';
import 'package:voxylive/services/user_service.dart';
import '../../live/live_player_screen.dart';

class DiscoverTab extends StatefulWidget {
  final String username;
  const DiscoverTab({super.key, required this.username});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  List allStreamers = [];
  List liveRooms = [];
  bool loading = true;


  @override
  void initState() {
    super.initState();
    loadStreamers();

    SocketService.connect();

    // ✅ FIX — pehle listener lagao, phir emit karo
    SocketService.listenLiveStreamers((data) {
      if (mounted) setState(() => liveRooms = data);
    });

    SocketService.socket?.on("streamer-offline", (data) {
      if (mounted)
        setState(() {
          liveRooms.removeWhere((s) => s["roomId"] == data["roomId"]);
        });
    });

    // ✅ Connected ho toh turant emit, nahi toh connect hone ka wait karo
    if (SocketService.socket != null && SocketService.socket!.connected) {
      SocketService.socket!.emit("get-live-streamers");
    } else {
      SocketService.socket?.once("connect", (_) {
        SocketService.socket!.emit("get-live-streamers");
      });
    }
  }

  Future<void> loadStreamers() async {
    try {
      final res = await UserService.getAllStreamers();
      setState(() {
        allStreamers = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  bool isLive(String username) {
    return liveRooms.any((r) => r["username"] == username);
  }

  Map? getLiveData(String username) {
    try {
      return liveRooms.firstWhere((r) => r["username"] == username);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE98834)),
      );
    }

    final liveStreamers = allStreamers
        .where((s) => isLive(s["username"]))
        .toList();
    final offlineStreamers = allStreamers
        .where((s) => !isLive(s["username"]))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (liveStreamers.isNotEmpty) ...[
            const Text(
              "🔴 Live Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...liveStreamers.map((s) => _streamerTile(s, live: true)),
            const SizedBox(height: 24),
          ],
          const Text(
            "All Streamers",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (offlineStreamers.isEmpty)
            const Text(
              "No other streamers",
              style: TextStyle(color: Colors.white38),
            )
          else
            ...offlineStreamers.map((s) => _streamerTile(s, live: false)),
        ],
      ),
    );
  }

  Widget _streamerTile(Map s, {required bool live}) {
    final liveData = getLiveData(s["username"]);

    return GestureDetector(
      onTap: live
          ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LivePlayerScreen(
                  room: liveData!["roomId"],
                  username: widget.username,
                  streamerUsername: s["username"],
                ),
              ),
            )
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B18),
          borderRadius: BorderRadius.circular(16),
          border: live ? Border.all(color: Colors.red, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF2A2A2A),
                  backgroundImage: s["avatar"] != null
                      ? NetworkImage(s["avatar"])
                      : null,
                  child: s["avatar"] == null
                      ? const Icon(Icons.person, color: Colors.white54)
                      : null,
                ),
                if (live)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s["username"] ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (live)
                    Text(
                      "${liveData?["viewers"] ?? 0} viewers",
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  if (!live)
                    const Text(
                      "Offline",
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                ],
              ),
            ),
            if (live) const Icon(Icons.chevron_right, color: Color(0xFFE98834)),
          ],
        ),
      ),
    );
  }
}
