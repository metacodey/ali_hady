// models/product_model.dart

import 'package:mc_utils/mc_utils.dart';

class ProductModel with CustomDropdownListFilter {
  final int? id;
  final String name;
  final String? description;
  final String sku;
  final double price;
  final int? quantity;
  final String? image;
  final bool isActive;
  final DateTime? createdAt;
  final String? categoryName;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    required this.sku,
    required this.price,
    this.quantity,
    this.image,
    this.isActive = true,
    this.createdAt,
    this.categoryName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      sku: json['sku'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      image: json['image'],
      isActive: (json['is_active'] == 1 || json['is_active'] == true),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "sku": sku,
      "price": price.toStringAsFixed(2),
      "quantity": quantity,
      "image": image,
      "is_active": isActive ? 1 : 0,
      "created_at": createdAt?.toIso8601String(),
      "category_name": categoryName,
    };
  }

  @override
  String toString() {
    //choose varible that you want to display in drop down btn
    return name;
  }

  @override
  bool filter(String query) {
    //choos varible that you want to search by it
    return name.toLowerCase().contains(query.toLowerCase());
  }
}
