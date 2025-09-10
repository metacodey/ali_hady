import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_model.dart';

class CustomerDetailsCard extends StatelessWidget {
  final OrderModel order;

  const CustomerDetailsCard({super.key, required this.order});

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
          Text(
            'معلومات العميل',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(Icons.person_outline, 'الاسم', order.customerName),
          SizedBox(height: 8.h),
          _buildInfoRow(
              Icons.email_outlined, 'البريد الإلكتروني', order.customerEmail),
          SizedBox(height: 8.h),
          _buildInfoRow(
              Icons.phone_outlined, 'رقم الهاتف', order.customerPhone),
          SizedBox(height: 8.h),
          // _buildInfoRow(
          //     Icons.location_city_outlined, 'المدينة', order.customerCity),
          // SizedBox(height: 8.h),
          // _buildInfoRow(
          //     Icons.location_on_outlined, 'العنوان', order.customerAddress),
          if (order.customerNotes != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(
                Icons.note_outlined, 'ملاحظات العميل', order.customerNotes!),
          ],
          if (order.adminNotes != null) ...[
            SizedBox(height: 8.h),
            _buildInfoRow(Icons.admin_panel_settings_outlined,
                'ملاحظات الإدارة', order.adminNotes!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: Colors.grey.shade600,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
