import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  final List<String> notifications = const [
    "تمت إضافة منتج جديد",
    "تمت الموافقة على تسديدك",
    "تم إرسال إشعار من الإدارة",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: notifications.isEmpty
          ? const Center(child: Text("لا توجد إشعارات"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(notifications[index]),
                  ),
                );
              },
            ),
    );
  }
}
