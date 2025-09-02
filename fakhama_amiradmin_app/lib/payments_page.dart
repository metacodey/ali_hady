import 'package:flutter/material.dart';

class PaymentsPage extends StatefulWidget {
  final List<Map<String, dynamic>> payments;

  const PaymentsPage({
    super.key,
    required this.payments,
  });

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  late List<Map<String, dynamic>> paymentsCopy;
  final TextEditingController paymentController = TextEditingController();
  int? editingIndex; // مؤشر الدفعة الجاري تعديلها

  @override
  void initState() {
    super.initState();
    paymentsCopy = List<Map<String, dynamic>>.from(widget.payments);
  }

  void addOrEditPayment() {
    if (paymentController.text.isEmpty) return;

    setState(() {
      double amount = double.tryParse(paymentController.text) ?? 0;

      if (editingIndex == null) {
        // إضافة جديدة
        paymentsCopy.add({
          "amount": amount,
          "date": DateTime.now(),
        });
      } else {
        // تعديل دفعة موجودة
        paymentsCopy[editingIndex!] = {
          "amount": amount,
          "date": DateTime.now(),
        };
        editingIndex = null;
      }

      paymentController.clear();
    });
  }

  void editPayment(int index) {
    setState(() {
      paymentController.text = paymentsCopy[index]['amount'].toString();
      editingIndex = index;
    });
  }

  void deletePayment(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذه الدفعة؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              setState(() {
                paymentsCopy.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جميع التسديدات"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, paymentsCopy);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: paymentController,
                    decoration: InputDecoration(
                      labelText: editingIndex == null ? "إضافة دفعة جديدة" : "تعديل الدفعة",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  onPressed: addOrEditPayment,
                  icon: Icon(editingIndex == null ? Icons.add_circle : Icons.save),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paymentsCopy.length,
                itemBuilder: (context, index) {
                  final pay = paymentsCopy[index];
                  return ListTile(
                    title: Text("💰 ${pay['amount']} د.ع"),
                    subtitle: Text(pay['date'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => editPayment(index), icon: const Icon(Icons.edit)),
                        IconButton(onPressed: () => deletePayment(index), icon: const Icon(Icons.delete)),
                      ],
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
