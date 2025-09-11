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
  final VoidCallback? onChat;

  const ItemClient({
    super.key,
    required this.client,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - الصف الأول المدمج
                _buildHeader(),

                SizedBox(height: 12.h),

                // Contact & Location Row - صف واحد مدمج
                _buildContactRow(),

                SizedBox(height: 12.h),

                // Financial & Conversation Summary - صفين مدمجين
                _buildSummarySection(),

                SizedBox(height: 12.h),

                // Action Buttons
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final unreadCount = client.unreadMessagesFromCustomer ??
        client.conversationsSummary?.unreadMessagesFromCustomer ??
        0;
    var color = _getPaymentStatusColor(client.financialSummary?.paymentStatus);
    return Row(
      children: [
        // Avatar with status indicator
        Stack(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: client.isActive
                      ? [Colors.green.shade300, Colors.green.shade600]
                      : [Colors.grey.shade300, Colors.grey.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            // Status dot
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: client.isActive ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),

        SizedBox(width: 12.w),

        // Name and basic info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.fullName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 6.sp,
                    color: client.isActive ? Colors.green : Colors.grey,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    client.isActive ? 'نشط الآن' : 'غير متاح',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: client.isActive
                          ? Colors.green.shade600
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        McCardItem(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          showShdow: false,
          color: color.withOpacity(0.15),
          colorBorder: color,
          widthBorder: 1.5,
          radius: BorderRadius.circular(15),
          child: McText(
            txt: McProcess.formatNumber(client.totalAmount.toString()),
            blod: true,
            fontSize: 9.sp,
            color: color,
          ),
        ),
        // Status badges
        SizedBox(width: 12.w),

        Row(
          children: [
            if (unreadCount > 0)
              Container(
                margin: EdgeInsets.only(left: 6.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.red.shade500,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications, size: 12.sp, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text(
                      '$unreadCount',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildContactItem(
            Icons.email_rounded,
            client.email,
            Colors.blue.shade600,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 2,
          child: _buildContactItem(
            Icons.phone_rounded,
            client.phone,
            Colors.green.shade600,
          ),
        ),
        if (client.city?.isNotEmpty == true) ...[
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: _buildContactItem(
              Icons.location_on_rounded,
              '${client.city}${client.country?.isNotEmpty == true ? ', ${client.country}' : ''}',
              Colors.orange.shade600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        // Financial Summary
        if (client.totalOrders != null || client.financialSummary != null)
          _buildSummaryCard(
            title: 'الملخص المالي',
            icon: Icons.account_balance_wallet_rounded,
            color: Colors.blue,
            badge: client.financialSummary?.paymentStatus != null
                ? _getPaymentStatusText(client.financialSummary!.paymentStatus)
                : null,
            badgeColor: client.financialSummary?.paymentStatus != null
                ? _getPaymentStatusColor(client.financialSummary!.paymentStatus)
                : null,
            items: [
              _SummaryItem(
                '${client.totalOrders ?? client.financialSummary?.totalOrders ?? 0}',
                'طلب',
                Icons.shopping_bag_rounded,
                Colors.blue.shade600,
              ),
              _SummaryItem(
                McProcess.formatNumber((client.totalPaid ??
                        client.financialSummary?.totalPaid ??
                        0.0)
                    .toString()),
                'مدفوع',
                Icons.trending_up_rounded,
                Colors.green.shade600,
              ),
              _SummaryItem(
                McProcess.formatNumber((client.remainingAmount ??
                        client.financialSummary?.remainingAmount ??
                        0.0)
                    .toString()),
                'متبقي',
                Icons.pending_rounded,
                _getPaymentStatusColor(client.financialSummary?.paymentStatus),
              ),
            ],
          ),

        // Conversations Summary
        if (client.totalConversations != null ||
            client.conversationsSummary != null) ...[
          SizedBox(height: 8.h),
          _buildSummaryCard(
            title: 'ملخص المحادثات',
            icon: Icons.chat_bubble_rounded,
            color: Colors.purple,
            badge: _getConversationBadgeText(),
            badgeColor: _getConversationBadgeColor(),
            items: [
              _SummaryItem(
                '${client.totalConversations ?? client.conversationsSummary?.totalConversations ?? 0}',
                'محادثة',
                Icons.chat_rounded,
                Colors.purple.shade600,
              ),
              _SummaryItem(
                '${client.openConversations ?? client.conversationsSummary?.openConversations ?? 0}',
                'مفتوحة',
                Icons.chat_bubble_rounded,
                Colors.blue.shade600,
              ),
              _SummaryItem(
                '${client.pendingConversations ?? client.conversationsSummary?.pendingConversations ?? 0}',
                'معلقة',
                Icons.pause_circle_rounded,
                Colors.orange.shade600,
              ),
              _SummaryItem(
                '${client.unreadMessagesFromCustomer ?? client.conversationsSummary?.unreadMessagesFromCustomer ?? 0}',
                'غير مقروءة',
                Icons.mark_chat_unread_rounded,
                Colors.red.shade600,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Color color,
    String? badge,
    Color? badgeColor,
    required List<_SummaryItem> items,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(icon, size: 16.sp, color: color.withOpacity(0.5)),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.5),
                ),
              ),
              Spacer(),
              if (badge != null && badgeColor != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          // Items
          Row(
            children: items
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  _SummaryItem item = entry.value;
                  return [
                    Expanded(child: _buildSummaryItemWidget(item)),
                    if (index < items.length - 1)
                      Container(
                        width: 1,
                        height: 20.h,
                        color: Colors.grey.shade300,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                      ),
                  ];
                })
                .expand((x) => x)
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItemWidget(_SummaryItem item) {
    return Column(
      children: [
        Icon(item.icon, size: 14.sp, color: item.color),
        SizedBox(height: 2.h),
        Text(
          item.value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: item.color,
          ),
        ),
        Text(
          item.label,
          style: TextStyle(
            fontSize: 9.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.phone_rounded,
          color: Colors.green.shade600,
          onPressed: () => _makePhoneCall(client.phone),
        ),
        SizedBox(width: 6.w),
        _buildActionButton(
          icon: Icons.chat_rounded,
          color: Colors.blue.shade600,
          onPressed: onChat,
        ),
        SizedBox(width: 6.w),
        _buildActionButton(
          icon: Icons.edit_rounded,
          color: Colors.orange.shade600,
          onPressed: onEdit,
        ),
        SizedBox(width: 6.w),
        _buildActionButton(
          icon: Icons.delete_rounded,
          color: Colors.red.shade600,
          onPressed: () => _showDeleteConfirmation(context),
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
        height: 38.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10.r),
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

  String? _getConversationBadgeText() {
    final unreadCount = client.unreadMessagesFromCustomer ??
        client.conversationsSummary?.unreadMessagesFromCustomer ??
        0;
    final pendingCount = client.pendingConversations ??
        client.conversationsSummary?.pendingConversations ??
        0;

    if (pendingCount > 0) return 'معلقة';
    if (unreadCount > 0) return 'يحتاج انتباه';
    return null;
  }

  Color? _getConversationBadgeColor() {
    final unreadCount = client.unreadMessagesFromCustomer ??
        client.conversationsSummary?.unreadMessagesFromCustomer ??
        0;
    final pendingCount = client.pendingConversations ??
        client.conversationsSummary?.pendingConversations ??
        0;

    if (pendingCount > 0) return Colors.orange.shade600;
    if (unreadCount > 0) return Colors.red.shade600;
    return null;
  }

  Color _getPaymentStatusColor(String? status) {
    switch (status) {
      case 'paid_up':
        return Colors.green.shade600;
      case 'has_debt':
        return Colors.orange.shade600;
      case 'unpaid':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status) {
      case 'paid_up':
        return 'مكتمل';
      case 'has_debt':
        return 'مديونية';
      case 'unpaid':
        return 'غير مدفوع';
      default:
        return 'غير محدد';
    }
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
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.red.shade600, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'تأكيد الحذف',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'هل تريد حذف "${client.fullName}"؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  _SummaryItem(this.value, this.label, this.icon, this.color);
}
