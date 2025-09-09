class PaymentOrderModel {
  final int id;
  final double amount;
  final String paymentMethod;
  final String status;
  final String? notes;
  final DateTime? paymentDate;
  final DateTime? createdAt;

  PaymentOrderModel({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.notes,
    this.paymentDate,
    this.createdAt,
  });

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) {
    return PaymentOrderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'notes': notes,
      'payment_date': paymentDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
