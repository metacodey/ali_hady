import 'package:fakhama_amiradmin_app/features/products/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemProduct extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ItemProduct({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Product Image
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.grey.shade100,
                      ),
                      child: product.image != null && product.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                product.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.grey.shade600,
                                  size: 24.sp,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.inventory_2_outlined,
                              color: Colors.grey.shade600,
                              size: 24.sp,
                            ),
                    ),
                    SizedBox(width: 12.w),
                    // Product Name & SKU
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'SKU: ${product.sku}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: product.isActive
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        product.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: product.isActive
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Product Info
                if (product.description?.isNotEmpty == true) ...[
                  _buildInfoRow(Icons.description_outlined, product.description!),
                  SizedBox(height: 6.h),
                ],
                _buildInfoRow(Icons.attach_money_outlined, '${product.price.toStringAsFixed(2)} ر.س'),
                SizedBox(height: 6.h),
                _buildInfoRow(Icons.inventory_outlined, 'الكمية: ${product.quantity ?? 0}'),

                if (product.categoryName?.isNotEmpty == true) ...[
                  SizedBox(height: 6.h),
                  _buildInfoRow(Icons.category_outlined, 'الفئة: ${product.categoryName}'),
                ],

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.visibility_outlined,
                      color: Colors.blue,
                      onPressed: onTap,
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      color: Colors.orange,
                      onPressed: onEdit,
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.delete_outline,
                      color: Colors.red,
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: Colors.grey.shade600,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Container(
        height: 36.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8.r),
            child: Icon(
              icon,
              color: color,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل تريد حذف "${product.name}"؟',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }
}