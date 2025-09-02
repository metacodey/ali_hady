import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      "تمت إضافة منتج جديد للمستخدم علي",
      "المستخدم حسين قام بتسديد 100,000 د.ع",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("الإشعارات")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, index) => ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}
