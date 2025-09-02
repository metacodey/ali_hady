import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

enum SortTypes with CustomDropdownListFilter {
  createdAt,
  returnNumber,
  clientName,
  grandTotal,
  currency;

  String get name {
    switch (this) {
      case SortTypes.createdAt:
        return 'created_at';
      case SortTypes.returnNumber:
        return 'return_number';
      case SortTypes.clientName:
        return 'client_name';
      case SortTypes.grandTotal:
        return 'grand_total';
      case SortTypes.currency:
        return 'currency';
    }
  }

  String get label {
    switch (this) {
      case SortTypes.createdAt:
        return 'sort_by_date'.tr;
      case SortTypes.returnNumber:
        return 'sort_by_return_number'.tr;
      case SortTypes.clientName:
        return 'sort_by_client'.tr;
      case SortTypes.grandTotal:
        return 'sort_by_amount'.tr;
      case SortTypes.currency:
        return 'sort_by_currency'.tr;
    }
  }

  IconData get icon {
    switch (this) {
      case SortTypes.createdAt:
        return Icons.calendar_today;
      case SortTypes.returnNumber:
        return Icons.receipt_long;
      case SortTypes.clientName:
        return Icons.person;
      case SortTypes.grandTotal:
        return Icons.attach_money;
      case SortTypes.currency:
        return Icons.monetization_on;
    }
  }

  static SortTypes selectType(String type) {
    switch (type) {
      case 'created_at':
        return SortTypes.createdAt;
      case 'return_number':
        return SortTypes.returnNumber;
      case 'client_name':
        return SortTypes.clientName;
      case 'grand_total':
        return SortTypes.grandTotal;
      case 'currency':
        return SortTypes.currency;
      default:
        return SortTypes.createdAt;
    }
  }

  @override
  String toString() {
    return label;
  }

  @override
  bool filter(String query) {
    return label.toLowerCase().contains(query.toLowerCase());
  }
}