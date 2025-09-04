import 'package:fakhama_amiradmin_app/features/orders/controllers/orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/models/order_model.dart';
import 'package:fakhama_amiradmin_app/features/orders/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mc_utils/mc_utils.dart';

class ItemOrder extends GetView<OrdersController> {
  final OrderModel order;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final Function(StatusModel)? onStatusChange;

  const ItemOrder({
    super.key,
    required this.order,
    this.onDelete,
    this.onTap,
    this.onStatusChange,
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
                    // Order Icon
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: _getStatusColor().withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: _getStatusColor(),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Order Number & Customer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'طلب #${order.orderNumber}',
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
                            order.customerName,
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
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        order.status.tr,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Order Info
                _buildInfoRow(Icons.phone_outlined, order.customerPhone),
                SizedBox(height: 6.h),
                _buildInfoRow(
                    Icons.attach_money_outlined,
                    McProcess.formatNumber(
                        order.totalAmount.toStringAsFixed(2))),
                SizedBox(height: 6.h),
                _buildInfoRow(
                    Icons.shopping_cart_outlined, '${order.itemsCount} عنصر'),

                if (order.createdAt != null) ...[
                  SizedBox(height: 6.h),
                  _buildInfoRow(
                      Icons.access_time_outlined,
                      DateFormat('yyyy/MM/dd - HH:mm')
                          .format(order.createdAt!)),
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
                      onPressed: () => _showStatusChangeDialog(context),
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

  Color _getStatusColor() {
    switch (order.status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.teal;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showStatusChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'تغيير حالة الطلب',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.statusOrder
              .map((status) => ListTile(
                    title: Text(status.description),
                    leading: Radio<StatusModel>(
                      value: status,
                      groupValue: controller.statusOrder
                          .where(
                            (p0) => p0.name == order.status,
                          )
                          .first,
                      onChanged: (value) {
                        Navigator.pop(context);
                        if (value != null && value.name != order.status) {
                          onStatusChange?.call(value);
                        }
                      },
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
        ],
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
          'هل تريد حذف الطلب "#${order.orderNumber}"؟',
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
