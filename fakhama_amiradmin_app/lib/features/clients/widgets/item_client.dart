import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
