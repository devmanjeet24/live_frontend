import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../services/stream_service.dart';
import '../../services/socket_service.dart';

class LivePlayerScreen extends StatefulWidget {
  final String room;
  final String username;

  const LivePlayerScreen({
    super.key,
    required this.room,
    required this.username,
  });

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

  Future<void> publishCamera() async {
    try {
      await room!.localParticipant?.setCameraEnabled(true);
      await room!.localParticipant?.setMicrophoneEnabled(true);
    } catch (e) {
      print("PUBLISH ERROR: $e");
    }
  }


  
  Future<void> init() async {
    try {
      SocketService.connect();
      SocketService.joinRoomAfterConnect({
        "roomId": widget.room,
        "username": widget.username,
      });

      SocketService.listenMessages((data) {
        print("🔥 RECEIVED: $data");
        setState(() {
          messages.add("${data['user']}: ${data['message']}");
        });
      });

      final res = await StreamService.getToken(widget.room);
      print("✅ TOKEN RES: $res");

      final url = "wss://voxylive-narna5pf.livekit.cloud";
      final token = res["token"];

      room = Room();

      await room!.connect(
        url,
        token,
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );

      print("✅ ROOM CONNECTED");

      if (res["isStreamer"] == true) {
        print("✅ STREAMER DETECTED, publishing camera...");
        await publishCamera();
      } else {
        print("👁 VIEWER MODE");
      }

      setState(() => loading = false);
    } catch (e) {
      print("❌ FULL ERROR: $e");
      print("❌ ERROR TYPE: ${e.runtimeType}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  @override
  void dispose() {
    SocketService.socket?.emit("leave-room", {
      "roomId": widget.room,
      "username": widget.username,
    });

    room?.disconnect();
    super.dispose();
  }

  final TextEditingController controller = TextEditingController();

  void send() {
    if (controller.text.trim().isEmpty) return;

    final msg = controller.text;

    /// 🔥 LOCAL ADD (IMPORTANT)
    // setState(() {
    //   messages.add("${widget.username}: $msg");
    // });

    SocketService.sendMessage(widget.room, msg, widget.username);

    controller.clear();
  }

  Widget buildVideo() {
    if (room == null) {
      return const Center(
        child: Text("Connecting...", style: TextStyle(color: Colors.white)),
      );
    }

    /// 🎯 STREAMER → own video
    final localPubs = room!.localParticipant?.videoTrackPublications ?? [];

    if (localPubs.isNotEmpty && localPubs.first.track != null) {
      return VideoTrackRenderer(localPubs.first.track!);
    }

    /// 🎯 VIEWER → remote video
    if (room!.remoteParticipants.isNotEmpty) {
      final participant = room!.remoteParticipants.values.first;

      final pubs = participant.videoTrackPublications
          .where((e) => e.track != null)
          .toList();

      if (pubs.isNotEmpty) {
        return VideoTrackRenderer(pubs.first.track!);
      }
    }

    /// fallback
    return const Center(
      child: Text(
        "Waiting for streamer...",
        style: TextStyle(color: Colors.white),
      ),
    );
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
                Positioned.fill(child: buildVideo()),

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

                /// 🔴 END BUTTON (TOP RIGHT)
                Positioned(
                  top: 40,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        SocketService.socket?.emit("leave-room", {
                          "roomId": widget.room,
                          "username": widget.username,
                        });

                        await room?.disconnect();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print("EXIT ERROR: $e");
                      }
                    },
                    child: const Text("End"),
                  ),
                ),
              ],
            ),
    );
  }
}
