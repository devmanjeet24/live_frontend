import 'package:flutter/material.dart';

class StreamerCard extends StatelessWidget {
  final String imagePath;

  const StreamerCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          /// IMAGE
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),

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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.white, size: 12),
                  SizedBox(width: 3),
                  Text("12",
                      style: TextStyle(color: Colors.white, fontSize: 11)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage:
                        AssetImage("assets/images/avattar.png"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Name of the Streamer",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "MuseoModerno",
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "13.25M",
                          style: TextStyle(
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