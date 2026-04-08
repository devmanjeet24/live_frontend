import 'package:flutter/material.dart';

class LiveChatWidget extends StatefulWidget {
  const LiveChatWidget({super.key});

  @override
  State<LiveChatWidget> createState() => _LiveChatWidgetState();
}

class _LiveChatWidgetState extends State<LiveChatWidget> {
  final TextEditingController controller = TextEditingController();

  List<String> messages = [
    "User1: Hello 🔥",
    "User2: Nice stream!",
  ];

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add("You: ${controller.text}");
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// MESSAGES
          Expanded(
            child: ListView(
              children: messages
                  .map((m) => Text(m, style: const TextStyle(color: Colors.white)))
                  .toList(),
            ),
          ),

          /// INPUT
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Type message...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send, color: Colors.orange),
              )
            ],
          )
        ],
      ),
    );
  }
}