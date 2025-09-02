import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'text': _messageController.text.trim()});
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var msg = messages[index];
              bool isUser = msg['sender'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg['text']!,
                    style: TextStyle(color: isUser ? Colors.white : Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                      hintText: "اكتب رسالتك...", border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: sendMessage, child: const Text("إرسال"))
            ],
          ),
        ),
      ],
    );
  }
}
