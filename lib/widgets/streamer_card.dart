import 'package:flutter/material.dart';

class StreamerCard extends StatelessWidget {
  // final String imagePath;
  final String streamerName;
  final String viewers;
  final String avatarUrl;

  const StreamerCard({
    super.key,
    // required this.imagePath,
    this.streamerName = "Streamer",
    this.viewers = "0",
    this.avatarUrl = "",
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          /// IMAGE
          // Positioned.fill(child: Image.network(imagePath, fit: BoxFit.cover)),
          Positioned.fill(
            child: avatarUrl.isNotEmpty
                ? Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      "assets/images/streamer1.png",
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset("assets/images/streamer1.png", fit: BoxFit.cover),
          ),

          /// TOP LEFT (views)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    viewers,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM INFO
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl) // server se image
                        : const AssetImage("assets/images/avattar.png")
                              as ImageProvider,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          streamerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "MuseoModerno",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "$viewers viewers",
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white70,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
