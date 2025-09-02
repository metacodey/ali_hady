import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'notifications_page.dart';
import 'payments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  double totalAmount = 0;
  List<Map<String, dynamic>> products = [
    {'name': 'منتج 1', 'price': 5000},
    {'name': 'منتج 2', 'price': 3000},
  ];

  List<Map<String, dynamic>> payments = [
    {'amount': 2000, 'date': DateTime.now()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // لحساب المبلغ الإجمالي
  double getTotal() {
    double sum = products.fold(0, (prev, element) => prev + (element['price']?.toDouble() ?? 0));

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      // الصفحة الرئيسية: المنتجات والمبلغ
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "المبلغ الإجمالي:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("${getTotal().toStringAsFixed(0)} د.ع",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "المنتجات:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var p = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(p['name']),
                      trailing: Text("${p['price']} د.ع"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // صفحة التسديدات
      PaymentsPage(payments: payments),

      // صفحة المحادثة
      const ChatPage(),

      // صفحة الإشعارات
      const NotificationsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("مجمع فخامة الامير"),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "التسديدات"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "المحادثة"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "الإشعارات"),
        ],
      ),
    );
  }
}
