import 'package:flutter/material.dart';
import 'package:voxylive/services/socket_service.dart';
import 'package:voxylive/widgets/category_tabs.dart';
import 'package:voxylive/widgets/streamer_card.dart';
import '../../live/live_player_screen.dart';

class LiveTab extends StatefulWidget {
  final String username;
  const LiveTab({super.key, required this.username});

  @override
  State<LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends State<LiveTab> {
  List streamers = [];

  @override
  void initState() {
    super.initState();

    SocketService.connect();

    SocketService.listenLiveStreamers((data) {
      if (mounted) setState(() => streamers = data);
    });

    // ✅ streamer-offline listener
    SocketService.socket?.on("streamer-offline", (data) {
      if (mounted)
        setState(() {
          streamers.removeWhere((s) => s["roomId"] == data["roomId"]);
        });
    });

    // ✅ Connected check
    if (SocketService.socket != null && SocketService.socket!.connected) {
      SocketService.socket!.emit("get-live-streamers");
    } else {
      SocketService.socket?.once("connect", (_) {
        SocketService.socket!.emit("get-live-streamers");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CategoryTabs(),
        const SizedBox(height: 20),

        /// ❌ EMPTY STATE
        if (streamers.isEmpty)
          const Center(
            child: Text(
              "No one is live 😴",
              style: TextStyle(color: Colors.white),
            ),
          ),

        /// ✅ GRID — StreamerCard design use ho raha hai
        if (streamers.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: streamers.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final s = streamers[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LivePlayerScreen(
                            room: s["roomId"],
                            username: widget.username,
                            streamerUsername: s["username"],
                          ),
                        ),
                      );
                    },

                    /// StreamerCard wala original design
                    child: StreamerCard(
                      // imagePath: "assets/images/streamer${(index % 6) + 1}.png",
                      streamerName: s["username"] ?? "Unknown",
                      viewers: s["viewers"]?.toString() ?? "0",
                      avatarUrl: s["avatar"] ?? "",
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

// class LiveTab extends StatelessWidget {
//   final String username;
//   const LiveTab({super.key, required this.username});

//   @override
//   Widget build(BuildContext context) {
//     // final images = [
//     //   "assets/images/streamer1.png",
//     //   "assets/images/streamer2.png",
//     //   "assets/images/streamer3.png",
//     //   "assets/images/streamer4.png",
//     //   "assets/images/streamer5.png",
//     //   "assets/images/streamer6.png",
//     // ];

//     return Column(
//       children: [
//         const CategoryTabs(),
//         const SizedBox(height: 20),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => LivePlayerScreen(room: "global_room", username: username,),
//                 ),
//               );
//             },
//             child: const Text("JOIN LIVE STREAM"),
//           ),
//         ),
//         // Expanded(
//         //   child: Padding(
//         //     padding: const EdgeInsets.symmetric(horizontal: 20),
//         //     child: GridView.builder(
//         //       padding: const EdgeInsets.only(bottom: 10),
//         //       itemCount: 20,
//         //       physics: const BouncingScrollPhysics(),
//         //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         //         crossAxisCount: 2,
//         //         mainAxisSpacing: 12,
//         //         crossAxisSpacing: 12,
//         //         childAspectRatio: 0.75,
//         //       ),
//         //       itemBuilder: (context, index) {
//         //         // return StreamerCard(
//         //         //   imagePath: images[index % images.length],
//         //         // );

//         //         return GestureDetector(
//         //           onTap: () {
//         //             Navigator.push(
//         //               context,
//         //               MaterialPageRoute(
//         //                 builder: (_) => LivePlayerScreen(room: "global_room"),
//         //               ),
//         //             );
//         //           },
//         //           child: StreamerCard(imagePath: images[index % images.length]),
//         //         );
//         //       },
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
