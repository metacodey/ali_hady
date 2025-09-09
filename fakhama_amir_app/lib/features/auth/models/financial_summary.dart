// ignore_for_file: public_member_api_docs, sort_constructors_first
// models/user_model.dart

class FinancialSummary {
  final int totalOrders;
  final double totalAmount;
  final double totalPaid;
  final double remainingAmount;
  final String paymentStatus;

  FinancialSummary({
    required this.totalOrders,
    required this.totalAmount,
    required this.totalPaid,
    required this.remainingAmount,
    required this.paymentStatus,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalOrders: int.tryParse(json['total_orders'].toString()) ?? 0,
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      totalPaid: double.tryParse(json['total_paid'].toString()) ?? 0.0,
      remainingAmount:
          double.tryParse(json['remaining_amount'].toString()) ?? 0.0,
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_amount': totalAmount,
      'total_paid': totalPaid,
      'remaining_amount': remainingAmount,
      'payment_status': paymentStatus,
    };
  }
}
