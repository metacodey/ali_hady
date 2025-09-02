// models/status_model.dart

import 'package:mc_utils/mc_utils.dart';

class StatusModel with CustomDropdownListFilter {
  final int id;
  final String name;
  final String description;
  final String color;
  final int sortOrder;

  StatusModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.sortOrder,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '',
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "color": color,
      "sort_order": sortOrder,
    };
  }

  @override
  String toString() {
    //choose varible that you want to display in drop down btn
    return description;
  }

  @override
  bool filter(String query) {
    //choos varible that you want to search by it
    return description.toLowerCase().contains(query.toLowerCase());
  }
}
