import 'package:flutter/material.dart';
import 'user_details_page.dart';
import 'notifications_page.dart';
import 'chat_users_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final TextEditingController searchController = TextEditingController();

  // بيانات مؤقتة
  final List<Map<String, dynamic>> allUsers = [
    {
      "name": "علي محمد",
      "phone": "0770000000",
      "address": "بغداد",
      "total": 250000,
    },
    {
      "name": "حسين أحمد",
      "phone": "0781111111",
      "address": "النجف",
      "total": 150000,
    },
    {
      "name": "سارة كريم",
      "phone": "0772222222",
      "address": "البصرة",
      "total": 300000,
    },
  ];

  List<Map<String, dynamic>> displayedUsers = [];

  @override
  void initState() {
    super.initState();
    displayedUsers = List.from(allUsers);

    searchController.addListener(() {
      final query = searchController.text.toLowerCase();
      setState(() {
        displayedUsers = allUsers.where((user) {
          final name = user['name'].toString().toLowerCase();
          final phone = user['phone'].toString();
          return name.contains(query) || phone.contains(query);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة تحكم الأدمن"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatUsersPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "بحث عن مستخدم بالاسم أو رقم الهاتف",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: displayedUsers.length,
                itemBuilder: (context, index) {
                  final user = displayedUsers[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(user["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("📞 ${user["phone"]}"),
                          Text("📍 ${user["address"]}"),
                          Text("💰 المبلغ: ${user["total"]} د.ع"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailsPage(
                                name: user["name"],
                                phone: user["phone"],
                                address: user["address"],
                              ),
                            ),
                          );
                        },
                        child: const Text("فتح"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
