import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

enum SortOrder with CustomDropdownListFilter {
  ascending,
  descending;

  String get name {
    switch (this) {
      case SortOrder.ascending:
        return 'asc';
      case SortOrder.descending:
        return 'desc';
    }
  }

  String get label {
    switch (this) {
      case SortOrder.ascending:
        return 'ascending'.tr;
      case SortOrder.descending:
        return 'descending'.tr;
    }
  }

  IconData get icon {
    switch (this) {
      case SortOrder.ascending:
        return Icons.arrow_upward;
      case SortOrder.descending:
        return Icons.arrow_downward;
    }
  }

  bool get isAscending {
    return this == SortOrder.ascending;
  }

  bool get isDescending {
    return this == SortOrder.descending;
  }

  static SortOrder selectOrder(String order) {
    switch (order) {
      case 'asc':
        return SortOrder.ascending;
      case 'desc':
        return SortOrder.descending;
      default:
        return SortOrder.descending;
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
