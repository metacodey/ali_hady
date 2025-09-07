import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/order_details_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/models/order_model.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/customer_details_card.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/order_items_widget.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/order_payments_widget.dart';
import 'package:fakhama_amiradmin_app/features/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class OrderDetailsScreen extends GetView<OrderDetailsController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: 'تفاصيل الطلب',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Obx(() {
        if (controller.statusRequest.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orderDetails.value == null) {
          return const Center(
            child: Text('لا توجد بيانات للطلب'),
          );
        }

        final order = controller.orderDetails.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              _buildOrderHeader(order),

              SizedBox(height: 16.h),

              // Customer Details
              CustomerDetailsCard(order: order),

              SizedBox(height: 16.h),

              // Order Items
              OrderItemsWidget(items: order.items),

              SizedBox(height: 16.h),

              // Order Payments
              OrderPaymentsWidget(
                payments: order.payments,
                totalAmount: order.totalAmount,
                paidAmount: order.paidAmount,
                remainingAmount: order.remainingAmount,
                onAddPayment: () => _showAddPaymentDialog(context, order.id),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderHeader(OrderModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب #${order.orderNumber}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Color(int.parse(
                          order.statusColor.replaceFirst('#', '0xff')))
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  order.status.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(
                        int.parse(order.statusColor.replaceFirst('#', '0xff'))),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي المبلغ: ${McProcess.formatNumber(order.totalAmount.toStringAsFixed(2))}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                'حالة الدفع: ${order.paymentStatus}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _getPaymentStatusColor(order),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPaymentStatusColor(OrderModel order) {
    if (order.paidAmount >= order.totalAmount) {
      return Colors.green;
    } else if (order.paidAmount > 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showAddPaymentDialog(BuildContext context, int orderId) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    String selectedMethod = 'نقداً';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(
          'إضافة دفعة جديدة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              value: selectedMethod,
              decoration: const InputDecoration(
                labelText: 'طريقة الدفع',
                border: OutlineInputBorder(),
              ),
              items: ['نقداً', 'بطاقة ائتمان', 'تحويل بنكي']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedMethod = value;
              },
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'ملاحظات (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isNotEmpty) {
                final paymentData = {
                  'amount': double.parse(amountController.text),
                  'payment_method': selectedMethod,
                  'notes': notesController.text.isEmpty
                      ? null
                      : notesController.text,
                };
                controller.addPayment(orderId, paymentData);
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
