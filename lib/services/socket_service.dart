import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String username;
  late IO.Socket socket;

  final Function(Map<String, dynamic>) onNewMessage;
  final Function(String) onUserTyping;
  final Function() onStopTyping;
  final Function(String) onUserJoined;
  final Function(String) onUserLeft;

  SocketService({
    required this.username,
    required this.onNewMessage,
    required this.onUserTyping,
    required this.onStopTyping,
    required this.onUserJoined,
    required this.onUserLeft,
  });

  void connect() {
    socket = IO.io('http://192.168.29.205:3000', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      socket.emit('add user', username);
    });

    socket.on('login', (_) {
      onUserJoined(username);
    });

    socket.on('user joined', (data) {
      onUserJoined(data['username']);
    });

    socket.on('user left', (data) {
      onUserLeft(data['username']);
    });

    socket.on('new message', (data) {
      onNewMessage({
        'type': 'chat',
        'username': data['username'],
        'message': data['message'],
        'time': DateTime.now().toString()
      });
    });

    socket.on('typing', (data) {
      onUserTyping(data['username']);
    });

    socket.on('stop typing', (_) {
      onStopTyping();
    });
  }

  void sendMessage(String message) {
    socket.emit('new message', message);
  }

  void typing() {
    socket.emit('typing');
  }

  void stopTyping() {
    socket.emit('stop typing');
  }

  void dispose() {
    socket.dispose();
  }
}
