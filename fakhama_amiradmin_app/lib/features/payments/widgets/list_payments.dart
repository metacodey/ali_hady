import 'package:fakhama_amiradmin_app/features/payments/controllers/payment_controller.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/item_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class ListPayments extends GetView<PaymentController> {
  const ListPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: Obx(() {
          var payments = controller.filteredPayments;
          var length = payments.length + (controller.hasMoreData.value ? 1 : 0);

          return ListView.builder(
              controller: controller.scroller,
              itemCount: length,
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              itemBuilder: (context, index) {
                if (index == (length) - 1 && controller.hasMoreData.value) {
                  return _buildLoadMoreIndicator();
                }
                if (index >= payments.length) {
                  return const SizedBox.shrink();
                }
                var payment = controller.filteredPayments[index];
                return ItemPayment(
                  payment: payment,
                  onTap: () {
                    _showPaymentDetails(context, payment);
                  },
                  onEdit: () {
                    controller.editPayment(payment);
                  },
                  onDelete: () {
                    if (payment.id == null) return;
                    controller.deletePayment(payment.id!);
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
              'تم عرض جميع الدفعات',
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

  void _showPaymentDetails(BuildContext context, payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الدفعة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الطلب: ${payment.orderNumber}'),
            Text('اسم العميل: ${payment.customerName}'),
            Text('المبلغ: ${payment.amount} ر.س'),
            Text('طريقة الدفع: ${payment.paymentMethod}'),
            Text('الحالة: ${payment.statusInArabic}'),
            if (payment.paymentDate != null)
              Text(
                  'تاريخ الدفع: ${payment.paymentDate.toString().split(' ')[0]}'),
            if (payment.createdAt != null)
              Text(
                  'تاريخ الإنشاء: ${payment.createdAt.toString().split(' ')[0]}'),
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
