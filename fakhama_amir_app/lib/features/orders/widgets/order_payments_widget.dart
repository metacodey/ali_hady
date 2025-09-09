import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mc_utils/mc_utils.dart';

import '../models/payment_order_model.dart';

class OrderPaymentsWidget extends StatelessWidget {
  final List<PaymentOrderModel> payments;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final VoidCallback? onAddPayment;

  const OrderPaymentsWidget({
    super.key,
    required this.payments,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
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
                'المدفوعات (${payments.length})',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              if (remainingAmount > 0 && onAddPayment != null)
                ElevatedButton.icon(
                  onPressed: onAddPayment,
                  icon: Icon(Icons.add, size: 16.sp),
                  label: const Text('إضافة دفعة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // Payment Summary
          _buildPaymentSummary(),

          if (payments.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.grey.shade200),
            SizedBox(height: 12.h),

            // Payment List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final payment = payments[index];
                return _buildPaymentItem(payment);
              },
            ),
          ] else ...[
            SizedBox(height: 16.h),
            Center(
              child: Text(
                'لا توجد مدفوعات بعد',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إجمالي الطلب:',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                McProcess.formatNumber(totalAmount.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المبلغ المدفوع:',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                McProcess.formatNumber(paidAmount.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المبلغ المتبقي:',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                McProcess.formatNumber(remainingAmount.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: remainingAmount > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(PaymentOrderModel payment) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                McProcess.formatNumber(payment.amount.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  payment.status == 'paid' ? 'مدفوع' : payment.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                Icons.payment_outlined,
                size: 14.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 4.w),
              Text(
                payment.paymentMethod,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time_outlined,
                size: 14.sp,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 4.w),
              Text(
                payment.paymentDate != null
                    ? DateFormat('yyyy/MM/dd - HH:mm')
                        .format(payment.paymentDate!)
                    : 'غير محدد',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          if (payment.notes != null) ...[
            SizedBox(height: 6.h),
            Text(
              'ملاحظات: ${payment.notes}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
