import 'package:mc_utils/mc_utils.dart';

import 'order_item_model.dart';
import 'payment_order_model.dart';

class OrderModel with CustomDropdownListFilter {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final String? customerNotes;
  final String? adminNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerCity;
  final String customerAddress;
  final String status;
  final String statusColor;
  final double paidAmount;
  final double remainingAmount;
  final String paymentStatus;
  final String paymentPercentage;
  final List<OrderItemModel> items;
  final List<PaymentOrderModel> payments;

  // Computed properties
  int get itemsCount => items.length;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    this.customerNotes,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerCity,
    required this.customerAddress,
    required this.status,
    required this.statusColor,
    required this.paidAmount,
    required this.remainingAmount,
    required this.paymentStatus,
    required this.paymentPercentage,
    required this.items,
    required this.payments,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      customerNotes: json['customer_notes'],
      adminNotes: json['admin_notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerCity: json['customer_city'] ?? '',
      customerAddress: json['customer_address'] ?? '',
      status: json['status'] ?? '',
      statusColor: json['status_color'] ?? '#000000',
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      remainingAmount: (json['remaining_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? '',
      paymentPercentage: json['payment_percentage']?.toString() ?? '0',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((payment) => PaymentOrderModel.fromJson(payment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'customer_notes': customerNotes,
      'admin_notes': adminNotes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'customer_city': customerCity,
      'customer_address': customerAddress,
      'status': status,
      'status_color': statusColor,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'payment_status': paymentStatus,
      'payment_percentage': paymentPercentage,
      'items': items.map((item) => item.toJson()).toList(),
      'payments': payments.map((payment) => payment.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return orderNumber;
  }

  @override
  bool filter(String query) {
    return orderNumber.toLowerCase().contains(query.toLowerCase()) ||
        customerName.toLowerCase().contains(query.toLowerCase());
  }
}
