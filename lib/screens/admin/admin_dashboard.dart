import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../utils/loader.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await AdminService.getRequests();

      setState(() {
        requests = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> approve(String id) async {
    try {
      Loader.show(context);
      await AdminService.approve(id);
      Loader.hide(context);
      load();
    } catch (e) {
      Loader.hide(context);
    }
  }

  Future<void> reject(String id) async {
    try {
      Loader.show(context);
      await AdminService.reject(id);
      Loader.hide(context);
      load();
    } catch (e) {
      Loader.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0F0B),
      appBar: AppBar(title: const Text("Requests")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (_, i) {
                final r = requests[i];

                return ListTile(
                  title: Text(
                    r["user"]["email"],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    r["status"],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => approve(r["_id"]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => reject(r["_id"]),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}