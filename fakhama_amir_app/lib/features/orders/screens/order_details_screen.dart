import 'package:fakhama_amir_app/core/class/statusrequest.dart';
import 'package:fakhama_amir_app/features/orders/widgets/customer_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../widgets/appbar_widget.dart';
import '../controllers/order_details_controller.dart';
import '../models/order_model.dart';
import '../widgets/order_items_widget.dart';
import '../widgets/order_payments_widget.dart';

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
}
