import 'package:flutter/material.dart';
import 'chat_page.dart';

class ChatUsersPage extends StatelessWidget {
  const ChatUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات مؤقتة للمستخدمين
    final List<Map<String, String>> users = [
      {"name": "علي محمد", "phone": "0770000000"},
      {"name": "حسين أحمد", "phone": "0781111111"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("المحادثات"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(user["name"]!),
              subtitle: Text("📞 ${user["phone"]}"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(userName: user["name"]!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
