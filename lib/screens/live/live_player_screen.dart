import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../services/stream_service.dart';
import '../../services/socket_service.dart';

class LivePlayerScreen extends StatefulWidget {
  final String room;

  const LivePlayerScreen({super.key, required this.room});

  @override
  State<LivePlayerScreen> createState() => _LivePlayerScreenState();
}

class _LivePlayerScreenState extends State<LivePlayerScreen> {
  Room? room;
  bool loading = true;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      /// SOCKET CONNECT
      SocketService.connect();
      SocketService.joinRoom(widget.room);

      SocketService.listenMessages((data) {
        setState(() {
          messages.add("${data['user']}: ${data['message']}");
        });
      });

      /// LIVEKIT TOKEN
      final res = await StreamService.getToken(widget.room);

      final url = "wss://voxylive-narna5pf.livekit.cloud";
      final token = res["token"];

      room = Room();

      await room!.connect(url, token, roomOptions: const RoomOptions());

      setState(() => loading = false);
    } catch (e) {
      print("LIVE ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to join stream")));
    }
  }

  @override
  void dispose() {
    room?.disconnect();
    super.dispose();
  }

  final TextEditingController controller = TextEditingController();

  void send() {
    if (controller.text.trim().isEmpty) return;

    SocketService.sendMessage(widget.room, controller.text);
    controller.clear();
  }

  Widget buildVideo() {
  // Room empty hai toh wait screen
  if (room == null || room!.remoteParticipants.isEmpty) {
    return const Center(
      child: Text(
        "Waiting for streamer...",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Pehla participant lo
  final participant = room!.remoteParticipants.values.first;

  // Uski video publications mein se track dhundho
  TrackPublication? videoPub;                          // ✅ pehle null rakho
  for (var pub in participant.videoTrackPublications) { // ✅ loop se dhundho
    if (pub.track != null) {
      videoPub = pub;                                  // ✅ mila toh assign karo
      break;                                           // ✅ loop band karo
    }
  }

  // Video nahi mili toh message dikhao
  if (videoPub == null) {
    return const Center(
      child: Text(
        "No video yet",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Video mili toh render karo
  // return VideoTrackRenderer(videoPub.track!);
  return VideoTrackRenderer(videoPub.track! as VideoTrack);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                /// VIDEO
                Positioned.fill(
                  child: buildVideo(),
                ),

                /// CHAT
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: ListView(
                          children: messages
                              .map(
                                (e) => Text(
                                  e,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                            onPressed: send,
                            icon: const Icon(Icons.send, color: Colors.orange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
