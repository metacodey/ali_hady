import 'package:flutter/material.dart';

class PaymentsPage extends StatelessWidget {
  final List<Map<String, dynamic>> payments;

  const PaymentsPage({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "التسديدات:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: payments.isEmpty
                ? const Center(child: Text("لا توجد تسديدات"))
                : ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      var pay = payments[index];
                      return Card(
                        child: ListTile(
                          title: Text("المبلغ: ${pay['amount']} د.ع"),
                          subtitle: Text("التاريخ: ${pay['date'].toString().substring(0, 16)}"),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
