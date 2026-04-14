import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:voxylive/services/coin_service.dart';
import 'package:voxylive/utils/storage.dart';
import 'package:voxylive/widgets/gift_panel.dart';
import '../../services/stream_service.dart';
import '../../services/socket_service.dart';

class LivePlayerScreen extends StatefulWidget {
  final String room;
  final String username;
  final String streamerUsername;

  const LivePlayerScreen({
    super.key,
    required this.room,
    required this.username,
    required this.streamerUsername,
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
  int likes = 0;
  int dislikes = 0;
  bool isStreamer = false;
  bool isCameraOff = false;

  int coinBalance = 0;
  String streamerUsername = ""; // streamer ka username
  List<Map> giftAnimations = []; // screen pe flying gifts
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
      final res = await StreamService.getToken(widget.room);
      final accessToken = await Storage.getAccessToken();
      print("ACCESS TOKEN: $accessToken");
      streamerUsername = widget.streamerUsername;

      try {
        final coinRes = await CoinService.getBalance();
        setState(() => coinBalance = coinRes);
      } catch (e) {
        print("⚠️ Coin balance fetch failed (non-critical): $e");
        // coinBalance = 0 already set hai, stream continue karegi
      }

      isStreamer = res["isStreamer"] == true;
      print("IS STREAMER: $isStreamer");

      print("✅ TOKEN RES: $res");
      SocketService.connect();
      // gift receive karo
      SocketService.socket?.on("receive-gift", (data) {
        setState(() {
          giftAnimations.add(data);
        });
        // 3 second baad remove karo
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => giftAnimations.removeAt(0));
        });
      });
      SocketService.joinRoomAfterConnect({
        "roomId": widget.room,
        "username": widget.username,
        "isStreamer": res["isStreamer"],
        "avatar": res["avatar"] ?? "",
      });
      SocketService.listenMessages((data) {
        setState(() {
          messages.add("${data['user']}: ${data['message']}");
        });
        // auto scroll to bottom
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });
      SocketService.listenViewer((count) {
        setState(() => viewers = count);
      });
      SocketService.listenReaction((data) {
        setState(() {
          likes = data["likes"] ?? likes;
          dislikes = data["dislikes"] ?? dislikes;
        });
      });
      final url = "wss://voxylive-narna5pf.livekit.cloud";
      final token = res["token"] ?? "";
      room = Room();
      await room!.connect(
        url,
        token,
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );
      print("✅ ROOM CONNECTED");
      if (res["isStreamer"] == true) {
        await publishCamera();
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
    _scrollController.dispose();
    super.dispose();
  }

  void send() {
    if (controller.text.trim().isEmpty) return;
    final msg = controller.text;
    SocketService.sendMessage(widget.room, msg, widget.username);
    controller.clear();
  }

  Widget buildVideo() {
    if (room == null) {
      return const Center(
        child: Text("Connecting...", style: TextStyle(color: Colors.white)),
      );
    }
    final localPubs = room!.localParticipant?.videoTrackPublications ?? [];
    if (localPubs.isNotEmpty && localPubs.first.track != null) {
      return VideoTrackRenderer(localPubs.first.track!);
    }
    if (room!.remoteParticipants.isNotEmpty) {
      final participant = room!.remoteParticipants.values.first;
      final pubs = participant.videoTrackPublications
          .where((e) => e.track != null)
          .toList();
      if (pubs.isNotEmpty) return VideoTrackRenderer(pubs.first.track!);
    }
    return const Center(
      child: Text(
        "Waiting for streamer...",
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  /// 🎨 Single chat message bubble
  Widget _buildMessage(String msg) {
    final parts = msg.split(": ");
    final user = parts.length > 1 ? parts[0] : "";
    final text = parts.length > 1 ? parts.sublist(1).join(": ") : msg;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45),
              borderRadius: BorderRadius.circular(20),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$user  ",
                    style: const TextStyle(
                      color: Color(0xFFE98834),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: text,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE98834)),
            )
          : Stack(
              children: [
                /// 🎥 VIDEO — full screen
                Positioned.fill(child: buildVideo()),

                /// 🔴 TOP LEFT — LIVE + viewers
                Positioned(
                  top: 50,
                  left: 16,
                  child: Row(
                    children: [
                      /// LIVE badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "● LIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      /// Viewers
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.remove_red_eye,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              viewers.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// ❌ TOP RIGHT — End button
                Positioned(
                  top: 46,
                  right: 16,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        SocketService.socket?.emit("leave-room", {
                          "roomId": widget.room,
                          "username": widget.username,
                        });
                        await room?.disconnect();
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        print("EXIT ERROR: $e");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "End",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                //  Mic
                if (isStreamer)
                  Positioned(
                    right: 14,
                    bottom: 120,
                    child: Column(
                      children: [
                        // MIC (existing)
                        _circleBtn(
                          icon: isMuted ? Icons.mic_off : Icons.mic,
                          color: isMuted ? Colors.red : Colors.white,
                          onTap: () async {
                            isMuted = !isMuted;
                            await room!.localParticipant?.setMicrophoneEnabled(
                              !isMuted,
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 12),
                        // CAMERA (naya)
                        _circleBtn(
                          icon: isCameraOff
                              ? Icons.videocam_off
                              : Icons.videocam,
                          color: isCameraOff ? Colors.red : Colors.white,
                          onTap: () async {
                            isCameraOff = !isCameraOff;
                            await room!.localParticipant?.setCameraEnabled(
                              !isCameraOff,
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),

                /// 🎙 RIGHT SIDE — Like/Dislike
                if (!isStreamer)
                  Positioned(
                    right: 14,
                    bottom: 120,
                    child: Column(
                      children: [
                        /// MIC
                        // _circleBtn(
                        //   icon: isMuted ? Icons.mic_off : Icons.mic,
                        //   color: isMuted ? Colors.red : Colors.white,
                        //   onTap: () async {
                        //     isMuted = !isMuted;
                        //     await room!.localParticipant?.setMicrophoneEnabled(
                        //       !isMuted,
                        //     );
                        //     setState(() {});
                        //   },
                        // ),
                        const SizedBox(height: 16),

                        /// LIKE
                        _circleBtn(
                          icon: Icons.thumb_up_rounded,
                          color: const Color(0xFF4CAF50),
                          onTap: () =>
                              SocketService.sendReaction(widget.room, "like"),
                        ),
                        Text(
                          "$likes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// DISLIKE
                        _circleBtn(
                          icon: Icons.thumb_down_rounded,
                          color: Colors.redAccent,
                          onTap: () => SocketService.sendReaction(
                            widget.room,
                            "dislike",
                          ),
                        ),
                        Text(
                          "$dislikes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!isStreamer)
                  Positioned(
                    right: 14,
                    bottom: 60,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (_) => GiftPanel(
                            roomId: widget.room,
                            streamerUsername: streamerUsername,
                            coinBalance: coinBalance,
                            onGiftSent: (newBalance) {
                              setState(() => coinBalance = newBalance);
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: const Text(
                          "🎁",
                          style: TextStyle(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                // Stack ke andar add karo
                ...giftAnimations.map(
                  (g) => Positioned(
                    bottom: 300,
                    left: 20,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (_, double v, __) => Opacity(
                        opacity: v > 0.8 ? (1 - v) * 5 : 1,
                        child: Transform.translate(
                          offset: Offset(0, -100 * v),
                          child: Text(
                            "${g['emoji']} ${g['senderName']} sent ${g['giftName']}!",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// 💬 BOTTOM — Chat + Input
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 80, // right side buttons ke liye space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Messages list
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: messages.length,
                          itemBuilder: (_, i) => _buildMessage(messages[i]),
                        ),
                      ),

                      /// Input row
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Say something...",
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                ),
                                onSubmitted: (_) => send(),
                              ),
                            ),
                            GestureDetector(
                              onTap: send,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE98834),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// 🔵 Reusable circle icon button
  Widget _circleBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
