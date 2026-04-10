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

  int viewers = 0;
  bool isMuted = false;
  List hearts = [];

  int likes = 0;
  int dislikes = 0;

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
      /// 🔥 STEP 1: पहले TOKEN लो
      final res = await StreamService.getToken(widget.room);
      print("✅ TOKEN RES: $res");

      /// 🔥 STEP 2: SOCKET CONNECT
      SocketService.connect();

      /// 🔥 STEP 3: JOIN ROOM (अब सही है)
      SocketService.joinRoomAfterConnect({
        "roomId": widget.room,
        "username": widget.username,
        "isStreamer": res["isStreamer"], 
        "avatar": res["avatar"] ?? "", 
      });

      /// 🔥 STEP 4: LISTENERS
      SocketService.listenMessages((data) {
        print("🔥LIVE STREAMERS RECEIVED: $data");
        setState(() {
          messages.add("${data['user']}: ${data['message']}");
        });
      });

      SocketService.listenViewer((count) {
        setState(() => viewers = count);
      });

      SocketService.listenReaction((data) {
        if (data["type"] == "like") {
          setState(() => likes++);
        } else {
          setState(() => dislikes++);
        }
      });

      /// 🔥 STEP 5: LIVEKIT CONNECT
      final url = "wss://voxylive-narna5pf.livekit.cloud";
      final token = res["token"];

      room = Room();

      await room!.connect(
        url,
        token,
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );

      print("✅ ROOM CONNECTED");

      /// 🔥 STEP 6: STREAMER CHECK
      if (res["isStreamer"] == true) {
        print("✅ STREAMER DETECTED, publishing camera...");
        await publishCamera();
      } else {
        print("👁 VIEWER MODE");
      }

      setState(() => loading = false);
    } catch (e) {
      print("❌ FULL ERROR: $e");
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

                //  Like + viewer
                Positioned(
                  top: 40,
                  left: 20,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.red,
                        child: Text("LIVE"),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(6),
                        color: Colors.black54,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                viewers.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Positioned(
                //   bottom: 180,
                //   right: 20,
                //   child: IconButton(
                //     icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
                //     onPressed: () async {
                //       isMuted = !isMuted;

                //       await room!.localParticipant?.setMicrophoneEnabled(
                //         !isMuted,
                //       );

                //       setState(() {});
                //     },
                //   ),
                // ),
                Positioned(
                  right: 20,
                  bottom: 180,
                  child: IconButton(
                    icon: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      isMuted = !isMuted;

                      await room!.localParticipant?.setMicrophoneEnabled(
                        !isMuted,
                      );

                      setState(() {});
                    },
                  ),
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

                Positioned(
                  right: 20,
                  bottom: 100,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.green),
                        onPressed: () {
                          SocketService.sendReaction(widget.room, "like");
                        },
                      ),
                      Text("$likes", style: TextStyle(color: Colors.white)),

                      SizedBox(height: 10),

                      IconButton(
                        icon: Icon(Icons.thumb_down, color: Colors.red),
                        onPressed: () {
                          SocketService.sendReaction(widget.room, "dislike");
                        },
                      ),
                      Text("$dislikes", style: TextStyle(color: Colors.white)),
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
