import 'package:flutter/material.dart';
import 'package:voxylive/widgets/category_tabs.dart';
// import 'package:voxylive/widgets/streamer_card.dart';
// import '../../live/live_player_screen.dart';
import '../../live/live_player_screen.dart';

class LiveTab extends StatelessWidget {
  final String username;
  const LiveTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // final images = [
    //   "assets/images/streamer1.png",
    //   "assets/images/streamer2.png",
    //   "assets/images/streamer3.png",
    //   "assets/images/streamer4.png",
    //   "assets/images/streamer5.png",
    //   "assets/images/streamer6.png",
    // ];

    return Column(
      children: [
        const CategoryTabs(),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LivePlayerScreen(room: "global_room", username: username,),
                ),
              );
            },
            child: const Text("JOIN LIVE STREAM"),
          ),
        ),
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     child: GridView.builder(
        //       padding: const EdgeInsets.only(bottom: 10),
        //       itemCount: 20,
        //       physics: const BouncingScrollPhysics(),
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         mainAxisSpacing: 12,
        //         crossAxisSpacing: 12,
        //         childAspectRatio: 0.75,
        //       ),
        //       itemBuilder: (context, index) {
        //         // return StreamerCard(
        //         //   imagePath: images[index % images.length],
        //         // );

        //         return GestureDetector(
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (_) => LivePlayerScreen(room: "global_room"),
        //               ),
        //             );
        //           },
        //           child: StreamerCard(imagePath: images[index % images.length]),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
