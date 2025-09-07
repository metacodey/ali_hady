import 'package:mc_utils/mc_utils.dart';

class PaymentModel with CustomDropdownListFilter {
  final int? id;
  final String amount;
  final String paymentMethod;
  final String status;
  final DateTime? paymentDate;
  final DateTime? createdAt;
  final String orderNumber;
  final String customerName;
  final String? note;

  PaymentModel({
    this.id,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.paymentDate,
    this.createdAt,
    this.note,
    required this.orderNumber,
    required this.customerName,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        amount: json['amount'] ?? '0.00',
        paymentMethod: json['payment_method'] ?? '',
        status: json['status'] ?? '',
        paymentDate: json['payment_date'] != null
            ? DateTime.tryParse(json['payment_date'])
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'])
            : null,
        orderNumber: json['order_number'] ?? '',
        customerName: json['customer_name'] ?? '',
        note: json['note'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "payment_method": paymentMethod,
      "status": status,
      "payment_date": paymentDate?.toIso8601String(),
      "created_at": createdAt?.toIso8601String(),
      "order_number": orderNumber,
      "customer_name": customerName,
      'note': note
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

  // Helper methods
  double get amountAsDouble => double.tryParse(amount) ?? 0.0;

  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  String get statusInArabic {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'مدفوع';
      case 'pending':
        return 'في الانتظار';
      case 'cancelled':
        return 'ملغي';
      default:
        return status;
    }
  }
}
