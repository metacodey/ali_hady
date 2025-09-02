import 'package:fakhama_amiradmin_app/features/orders/controllers/orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/item_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class ListOrders extends GetView<OrdersController> {
  const ListOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: Obx(() {
          var orders = controller.filteredOrders;
          var length = orders.length + (controller.hasMoreData.value ? 1 : 0);

          return ListView.builder(
              controller: controller.scroller,
              itemCount: length,
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              itemBuilder: (context, index) {
                if (index == (length) - 1 && controller.hasMoreData.value) {
                  return _buildLoadMoreIndicator();
                }
                if (index >= orders.length) {
                  return const SizedBox.shrink();
                }
                var order = controller.orders[index];
                return ItemOrder(
                  order: order,
                  onDelete: () {
                    controller.deleteOrder(order.id);
                  },
                  onStatusChange: (newStatus) {
                    // controller.updateOrderStatus(order.id, newStatus);
                  },
                  onTap: () {
                    _showOrderDetails(context, order);
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
              'تم عرض جميع الطلبات',
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

  void _showOrderDetails(BuildContext context, order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الطلب: #${order.orderNumber}'),
            Text('اسم العميل: ${order.customerName}'),
            Text('رقم الهاتف: ${order.customerPhone}'),
            Text(
                'المبلغ الإجمالي: ${order.totalAmount.toStringAsFixed(2)} ر.س'),
            Text('عدد العناصر: ${order.itemsCount}'),
            Text('الحالة: ${order.status}'),
            if (order.createdAt != null)
              Text('تاريخ الإنشاء: ${order.createdAt.toString()}'),
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
