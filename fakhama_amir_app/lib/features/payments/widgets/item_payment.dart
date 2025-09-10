import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../models/payment_model.dart';

class ItemPayment extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemPayment({
    super.key,
    required this.payment,
    this.onTap,
    this.onEdit,
    this.onDelete,
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
                    // Payment Icon
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: _getStatusColor().withOpacity(0.1),
                      ),
                      child: Icon(
                        _getPaymentIcon(),
                        color: _getStatusColor(),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Payment Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment.orderNumber,
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
                            payment.customerName,
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
                        payment.statusInArabic,
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

                // Payment Details
                _buildInfoRow(Icons.attach_money_outlined,
                    McProcess.formatNumber(payment.amount.toString())),
                SizedBox(height: 6.h),
                _buildInfoRow(Icons.payment_outlined,
                    'طريقة الدفع: ${payment.paymentMethod}'),

                if (payment.paymentDate != null) ...[
                  SizedBox(height: 6.h),
                  _buildInfoRow(Icons.calendar_today_outlined,
                      'تاريخ الدفع: ${payment.paymentDate.toString().split(' ')[0]}'),
                ],

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.visibility_outlined,
                        color: Colors.blue,
                        label: 'عرض',
                        onPressed: onTap,
                      ),
                    ),
                    // SizedBox(width: 8.w),
                    // Expanded(
                    //   child: _buildActionButton(
                    //     icon: Icons.edit_outlined,
                    //     color: Colors.orange,
                    //     label: 'تعديل',
                    //     onPressed: onEdit,
                    //   ),
                    // ),
                    // SizedBox(width: 8.w),
                    // Expanded(
                    //   child: _buildActionButton(
                    //     icon: Icons.delete_outline,
                    //     color: Colors.red,
                    //     label: 'حذف',
                    //     onPressed: onDelete,
                    //   ),
                    // ),
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
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 18.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (payment.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentIcon() {
    switch (payment.paymentMethod.toLowerCase()) {
      case 'نقداً':
      case 'cash':
        return Icons.money;
      case 'بطاقة ائتمان':
      case 'credit_card':
        return Icons.credit_card;
      case 'تحويل بنكي':
      case 'bank_transfer':
        return Icons.account_balance;
      case 'محفظة إلكترونية':
      case 'e_wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
}
