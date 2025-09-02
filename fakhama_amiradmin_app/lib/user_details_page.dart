import 'package:flutter/material.dart';
import 'payments_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String name;
  final String phone;
  final String address;

  const UserDetailsPage({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> payments = [];
  final TextEditingController productController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  double get total {
    double sum = 0;
    for (var p in products) sum += p['price'];
    for (var pay in payments) sum -= pay['amount'];
    return sum;
  }

  void addProduct() {
    if (productController.text.isNotEmpty && priceController.text.isNotEmpty) {
      setState(() {
        products.add({
          "name": productController.text,
          "price": double.tryParse(priceController.text) ?? 0,
        });
        productController.clear();
        priceController.clear();
      });
    }
  }

  void addPayment() {
    if (paymentController.text.isNotEmpty) {
      setState(() {
        payments.add({
          "amount": double.tryParse(paymentController.text) ?? 0,
          "date": DateTime.now(),
        });
        paymentController.clear();
      });
    }
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void deletePayment(int index) {
    setState(() {
      payments.removeAt(index);
    });
  }

  void updatePayments(List<Map<String, dynamic>> updatedPayments) {
    setState(() {
      payments = updatedPayments;
    });
  }

  // --- تأكيد الحذف للمنتج ---
  void confirmDeleteProduct(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذا المنتج؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              deleteProduct(index);
              Navigator.pop(context);
            },
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // تعديل المنتج مباشرة دون رسالة تأكيد
  void editProduct(int index) {
    productController.text = products[index]['name'];
    priceController.text = products[index]['price'].toString();
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📞 رقم الهاتف: ${widget.phone}"),
              Text("📍 العنوان: ${widget.address}"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("🔍 تتبع الموقع"),
              ),
              const SizedBox(height: 20),

              Text(
                "💰 الإجمالي: $total د.ع",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // إضافة / تعديل منتج
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: productController,
                      decoration: const InputDecoration(labelText: "اسم المنتج"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "السعر"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (productController.text.isNotEmpty && priceController.text.isNotEmpty) {
                        addProduct(); // إضافة المنتج مباشرة
                      }
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: products.asMap().entries.map((entry) {
                  int index = entry.key;
                  var product = entry.value;
                  return ListTile(
                    title: Text("${product['name']} - ${product['price']} د.ع"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () => editProduct(index), icon: const Icon(Icons.edit)),
                        IconButton(onPressed: () => confirmDeleteProduct(index), icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const Divider(),

              // إضافة تسديد
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: paymentController,
                      decoration: const InputDecoration(labelText: "مبلغ التسديد"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (paymentController.text.isNotEmpty) addPayment();
                    },
                    icon: const Icon(Icons.add_circle),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // زر جميع التسديدات
              ElevatedButton(
                onPressed: () async {
                  final updatedPayments = await Navigator.push<List<Map<String, dynamic>>>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentsPage(payments: payments),
                    ),
                  );
                  if (updatedPayments != null) updatePayments(updatedPayments);
                },
                child: const Text("📜 جميع التسديدات"),
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: const InputDecoration(labelText: "إرسال إشعار"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () {}, child: const Text("📩 إرسال"))
            ],
          ),
        ),
      ),
    );
  }
}
