import 'package:flutter/material.dart';
import '../../services/admin_gift_service.dart';

class GiftManagementScreen extends StatefulWidget {
  const GiftManagementScreen({super.key});
  @override
  State<GiftManagementScreen> createState() => _GiftManagementScreenState();
}

class _GiftManagementScreenState extends State<GiftManagementScreen> {
  List gifts = [];
  bool loading = true;

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    final data = await AdminGiftService.getAll();
    setState(() { gifts = data; loading = false; });
  }

  void showCreateDialog() {
    final typeC = TextEditingController();
    final nameC = TextEditingController();
    final emojiC = TextEditingController();
    final costC = TextEditingController();
    final diamondsC = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF1A1B18),
      title: const Text("New Gift", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        _field(typeC, "Type (e.g. rose)"),
        _field(nameC, "Name"),
        _field(emojiC, "Emoji"),
        _field(costC, "Coin Cost", number: true),
        _field(diamondsC, "Diamonds Earned", number: true),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE98834)),
          onPressed: () async {
            await AdminGiftService.create({
              "type": typeC.text, "name": nameC.text, "emoji": emojiC.text,
              "coinCost": int.parse(costC.text),
              "diamondsEarned": int.parse(diamondsC.text),
            });
            Navigator.pop(context);
            load();
          },
          child: const Text("Create", style: TextStyle(color: Colors.black)),
        ),
      ],
    ));
  }

  Widget _field(TextEditingController c, String hint, {bool number = false}) =>
    Padding(padding: const EdgeInsets.only(bottom: 8), child: TextField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true, fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none)),
    ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0F0B),
        title: const Text("Gift Management",
          style: TextStyle(color: Colors.white, fontFamily: "MuseoModerno")),
        actions: [
          IconButton(icon: const Icon(Icons.add, color: Color(0xFFE98834)),
            onPressed: showCreateDialog),
        ],
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE98834)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gifts.length,
            itemBuilder: (_, i) {
              final g = gifts[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF1A1B18),
                  borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Text(g["emoji"] ?? "🎁", style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g["name"] ?? "", style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                      Text("Cost: ${g["coinCost"]} coins · Earns: ${g["diamondsEarned"]} 💎",
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ])),
                  Switch(
                    value: g["isActive"] ?? false,
                    activeColor: const Color(0xFFE98834),
                    onChanged: (_) async {
                      await AdminGiftService.toggle(g["_id"]);
                      load();
                    },
                  ),
                ]),
              );
            }),
    );
  }
}