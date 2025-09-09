class OrderItemModel {
  final int id;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? productImage;
  final String productSku;

  OrderItemModel({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.productImage,
    required this.productSku,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0,
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0,
      productImage: json['product_image'],
      productSku: json['product_sku'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'product_image': productImage,
      'product_sku': productSku,
    };
  }
}
