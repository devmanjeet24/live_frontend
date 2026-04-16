import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  /// 🔌 CONNECT SOCKET
  static void connect() {
    if (socket != null && socket!.connected) {
      print("⚠️ Socket already connected");
      return;
    }

    socket = IO.io(
      "http://116.202.210.102:20355",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("🟢 SOCKET CONNECTED (GLOBAL): ${socket!.id}");
    });

    socket!.onDisconnect((_) {
      print("🔴 SOCKET DISCONNECTED");
    });

    socket!.onConnectError((err) {
      print("❌ SOCKET CONNECT ERROR: $err");
    });

    socket!.onError((err) {
      print("❌ SOCKET ERROR: $err");
    });
  }

  /// 🏠 JOIN ROOM
  static void joinRoom(Map<String, String> data) {
    if (socket == null || !socket!.connected) {
      print("❌ Socket not connected");
      return;
    }

    socket!.emit("join-room", data);
    print("➡️ Joined room: ${data["roomId"]} as ${data["username"]}");
  }

  static void joinRoomAfterConnect(Map<String, dynamic> data) {
    if (socket == null) return;

    if (socket!.connected) {
      // Already connected → seedha emit karo
      print("✅ Already connected, joining room directly...");
      socket!.emit("join-room", data);
    } else {
      // Wait for connect
      socket!.once("connect", (_) {
        print("✅ Connected now, joining room...");
        socket!.emit("join-room", data);
      });
    }
  }

  static void leaveRoom(String roomId, String username) {
    socket?.emit("leave-room", {"roomId": roomId, "username": username});

    print("⬅️ Left room: $roomId as $username");
  }

  /// 💬 SEND MESSAGE
  static void sendMessage(String roomId, String message, String username) {
    if (message.trim().isEmpty) {
      print("⚠️ Empty message blocked");
      return;
    }

    socket?.emit("send-message", {
      "roomId": roomId,
      "message": message,
      "user": username, // later dynamic karenge
    });

    print("📤 Sent: $message");
  }

  /// 📥 LISTEN MESSAGES
  static void listenMessages(Function(dynamic) callback) {
    if (socket == null) return;

    /// remove old listener (important)
    socket!.off("receive-message");

    socket!.on("receive-message", (data) {
      print("📩 MESSAGE RECEIVED: $data");
      callback(data);
    });
  }

  /// 👀 VIEWER COUNT
  static void listenViewer(Function(dynamic) cb) {
    socket?.on("viewer-count", cb);
  }

  /// ❤️ LIKE
  static void sendLike(String roomId) {
    socket?.emit("send-like", {"roomId": roomId});
  }

  static void listenLike(Function() cb) {
    socket?.on("receive-like", (_) => cb());
  }

  static void sendReaction(String roomId, String type) {
    socket?.emit("send-reaction", {"roomId": roomId, "type": type});
  }

  // listen
  static void listenReaction(Function(dynamic) callback) {
    socket?.off("receive-reaction");
    socket?.on("receive-reaction", (data) => callback(data));
  }

  /// 🎥 LIVE STREAMERS LIST
  static void listenLiveStreamers(Function(dynamic) cb) {
    socket?.off("live-streamers");
    socket?.on("live-streamers", cb);
  }

  /// 🔚 DISPOSE
  static void disconnect() {
    socket?.disconnect();
    socket = null;
    print(" Socket cleaned");
  }
}
