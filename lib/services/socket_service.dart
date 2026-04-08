import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  static void connect() {
    socket = IO.io(
      "http://116.202.210.102:20355",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("🟢 Connected");
    });

    socket!.onDisconnect((_) {
      print("🔴 Disconnected");
    });
  }

  static void joinRoom(String roomId) {
    socket?.emit("join-room", roomId);
  }

  static void sendMessage(String roomId, String message) {
    socket?.emit("send-message", {
      "roomId": roomId,
      "message": message,
      "user": "User",
    });
  }

  static void listenMessages(Function(dynamic) callback) {
    socket?.on("receive-message", callback);
  }
}