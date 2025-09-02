import 'package:fakhama_amiradmin_app/features/products/controllers/product_controller.dart';
import 'package:fakhama_amiradmin_app/features/products/widgets/item_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class ListProducts extends GetView<ProductController> {
  const ListProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: Obx(() {
          var products = controller.filteredProducts;
          var length = products.length + (controller.hasMoreData.value ? 1 : 0);

          return ListView.builder(
              controller: controller.scroller,
              itemCount: length,
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              itemBuilder: (context, index) {
                if (index == (length) - 1 && controller.hasMoreData.value) {
                  return _buildLoadMoreIndicator();
                }
                if (index >= products.length) {
                  return const SizedBox.shrink();
                }
                var product = controller.products[index];
                return ItemProduct(
                  product: product,
                  onDelete: () {
                    controller.deleteProduct(product.id!);
                  },
                  onEdit: () {
                    Get.toNamed(
                      '/product/add',
                      arguments: {'product': product},
                    );
                  },
                  onTap: () {
                    _showProductDetails(context, product);
                  },
                );
              });
        }));
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (!controller.hasMoreData.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Center(
            child: Text(
              'تم عرض جميع المنتجات',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      // التحميل التلقائي فقط
      return const SizedBox.shrink();
    });
  }

  void _showProductDetails(BuildContext context, product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل المنتج'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${product.name}'),
            Text('SKU: ${product.sku}'),
            Text('السعر: ${product.price.toStringAsFixed(2)} ر.س'),
            Text('الكمية: ${product.quantity ?? 0}'),
            if (product.description != null) Text('الوصف: ${product.description}'),
            if (product.categoryName != null) Text('الفئة: ${product.categoryName}'),
            Text('الحالة: ${product.isActive ? "نشط" : "غير نشط"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}