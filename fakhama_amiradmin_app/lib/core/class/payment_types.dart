import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

enum PaymentTypes with CustomDropdownListFilter {
  invoice,
  advance,
  refund;

  String get name {
    switch (this) {
      case PaymentTypes.invoice:
        return 'invoice';
      case PaymentTypes.advance:
        return 'advance';
      case PaymentTypes.refund:
        return 'refund';
    }
  }

  Color get color {
    switch (this) {
      case PaymentTypes.invoice:
        return Colors.blue;
      case PaymentTypes.advance:
        return Colors.green;
      case PaymentTypes.refund:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentTypes.invoice:
        return Icons.receipt_long;
      case PaymentTypes.advance:
        return Icons.payment;
      case PaymentTypes.refund:
        return Icons.money_off;
    }
  }

  bool get isInvoice {
    return this == PaymentTypes.invoice;
  }

  bool get isAdvance {
    return this == PaymentTypes.advance;
  }

  bool get isRefund {
    return this == PaymentTypes.refund;
  }

  static PaymentTypes selectType(String type) {
    switch (type) {
      case 'invoice':
        return PaymentTypes.invoice;
      case 'advance':
        return PaymentTypes.advance;
      case 'refund':
        return PaymentTypes.refund;
      default:
        return PaymentTypes.invoice;
    }
  }

  @override
  String toString() {
    //choose varible that you want to display in drop down btn
    return name.tr;
  }

  @override
  bool filter(String query) {
    //choos varible that you want to search by it
    return name.toLowerCase().contains(query.toLowerCase());
  }
}
