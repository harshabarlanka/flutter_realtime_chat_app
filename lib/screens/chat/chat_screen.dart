// chat_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging/services/socket_service.dart';
import 'package:messaging/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late SocketService socketService;
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isTyping = false;
  String typingUser = '';
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();
    socketService = SocketService(
      username: widget.username,
      onNewMessage: (msg) => setState(() => messages.add(msg)),
      onUserTyping: (u) => setState(() => typingUser = u),
      onStopTyping: () => setState(() => typingUser = ''),
      onUserJoined: (u) => setState(() => messages.add({'type': 'system', 'message': '$u joined the chat'})),
      onUserLeft: (u) => setState(() => messages.add({'type': 'system', 'message': '$u left the chat'})),
    );
    socketService.connect();
  }

  @override
  void dispose() {
    socketService.dispose();
    typingTimer?.cancel();
    super.dispose();
  }

  void sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      socketService.sendMessage(message);
      setState(() {
        messages.add({
          'type': 'chat',
          'username': widget.username,
          'message': message,
          'time': DateTime.now().toString()
        });
        _controller.clear();
      });
      socketService.stopTyping();
    }
  }

  void handleTyping(String value) {
    if (!isTyping) {
      isTyping = true;
      socketService.typing();
    }
    typingTimer?.cancel();
    typingTimer = Timer(const Duration(seconds: 1), () {
      isTyping = false;
      socketService.stopTyping();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Chat'),
        automaticallyImplyLeading: !kIsWeb,
      ),
      body: isWide
          ? Row(children: [Expanded(child: chatColumn())])
          : chatColumn(),
    );
  }

  Widget chatColumn() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              if (msg['type'] == 'system') {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(msg['message'],
                        style: const TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return ChatBubble(msg: msg, currentUser: widget.username);
            },
          ),
        ),
        if (typingUser.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('$typingUser is typing...',
                  style: const TextStyle(color: Colors.grey)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: handleTyping,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.black87,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 21),
                  onPressed: sendMessage,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
