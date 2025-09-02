// models/order_model.dart

class OrderModel {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final DateTime? createdAt;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerCity;
  final String customerNotes;
  final String adminNotes;
  final String status;
  final String statusColor;
  final int itemsCount;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    this.createdAt,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerCity,
    required this.customerNotes,
    required this.adminNotes,
    required this.status,
    required this.statusColor,
    required this.itemsCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      orderNumber: json['order_number'] ?? '',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerCity: json['customer_city'] ?? '',
      customerNotes: json['customer_notes'] ?? '',
      adminNotes: json['admin_notes'] ?? '',
      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '',
      itemsCount: int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order_number": orderNumber,
      "total_amount": totalAmount,
      "created_at": createdAt?.toIso8601String(),
      "customer_name": customerName,
      "customer_email": customerEmail,
      "customer_phone": customerPhone,
      "customer_city": customerCity,
      "customer_notes": customerNotes,
      "admin_notes": adminNotes,
      "status": status,
      "status_color": statusColor,
      "items_count": itemsCount,
    };
  }
}
