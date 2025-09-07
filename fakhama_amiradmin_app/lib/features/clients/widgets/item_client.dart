import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemClient extends StatelessWidget {
  final UserModel client;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ItemClient({
    super.key,
    required this.client,
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
                    // Avatar
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: client.isActive
                          ? Colors.green.shade100
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.person_rounded,
                        color: client.isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Name & Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.fullName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: 2.h),
                          // Text(
                          //   client.username,
                          //   style: TextStyle(
                          //     fontSize: 12.sp,
                          //     color: Colors.grey.shade600,
                          //   ),
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
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
                        color: client.isActive
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        client.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: client.isActive
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Contact Info
                _buildInfoRow(Icons.email_outlined, client.email),
                SizedBox(height: 6.h),
                _buildInfoRow(Icons.phone_outlined, client.phone),

                if (client.city?.isNotEmpty == true) ...[
                  SizedBox(height: 6.h),
                  _buildInfoRow(Icons.location_on_outlined,
                      '${client.city}${client.country?.isNotEmpty == true ? ', ${client.country}' : ''}'),
                ],

                // Financial Information
                if (client.totalOrders != null ||
                    client.financialSummary != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: Colors.blue.shade200, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16.sp,
                              color: Colors.blue.shade700,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'الملخص المالي',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Spacer(),
                            if (client.financialSummary?.paymentStatus != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: _getPaymentStatusColor(client
                                          .financialSummary!.paymentStatus)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  _getPaymentStatusText(
                                      client.financialSummary!.paymentStatus),
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _getPaymentStatusColor(
                                        client.financialSummary!.paymentStatus),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildCompactFinancialItem(
                                '${client.totalOrders ?? client.financialSummary?.totalOrders ?? 0}',
                                'طلب',
                                Icons.shopping_bag_outlined,
                                Colors.blue.shade600,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24.h,
                              color: Colors.grey.shade300,
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildCompactFinancialItem(
                                McProcess.formatNumber((client.totalAmount ??
                                        client.financialSummary?.totalAmount ??
                                        0.0)
                                    .toString()),
                                'مدفوع',
                                Icons.attach_money,
                                Colors.green.shade600,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24.h,
                              color: Colors.grey.shade300,
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildCompactFinancialItem(
                                McProcess.formatNumber(
                                    (client.remainingAmount ??
                                            client.financialSummary
                                                ?.remainingAmount ??
                                            0.0)
                                        .toString()),
                                'متبقي',
                                Icons.pending_outlined,
                                _getPaymentStatusColor(
                                    client.financialSummary?.paymentStatus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.phone,
                      color: Colors.green,
                      onPressed: () => _makePhoneCall(client.phone),
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      color: Colors.blue,
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactFinancialItem(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        McText(
          txt: value,
          fontSize: 11.sp,
          blod: true,
          color: color,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getPaymentStatusColor(String? status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'has_debt':
        return Colors.orange;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'paid':
        return 'مدفوع بالكامل';
      case 'has_debt':
        return 'يوجد مديونية';
      case 'unpaid':
        return 'غير مدفوع';
      default:
        return 'غير محدد';
    }
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
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
          'هل تريد حذف "${client.fullName}"؟',
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
