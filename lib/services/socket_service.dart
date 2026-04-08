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

    socket!.onConnect((_) {
      print("🟢 SOCKET CONNECTED: ${socket!.id}");
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
  static void joinRoom(String roomId) {
    if (socket == null || !socket!.connected) {
      print("❌ Socket not connected");
      return;
    }

    socket!.emit("join-room", roomId);
    print("➡️ Joined room: $roomId");
  }

  /// 🚪 LEAVE ROOM
  static void leaveRoom(String roomId) {
    socket?.emit("leave-room", roomId);
    print("⬅️ Left room: $roomId");
  }

  /// 💬 SEND MESSAGE
  static void sendMessage(String roomId, String message) {
    if (message.trim().isEmpty) {
      print("⚠️ Empty message blocked");
      return;
    }

    socket?.emit("send-message", {
      "roomId": roomId,
      "message": message,
      "user": "User", // later dynamic karenge
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

  /// 🔚 DISPOSE
  static void disconnect() {
    socket?.disconnect();
    socket = null;
    print(" Socket cleaned");
  }
}