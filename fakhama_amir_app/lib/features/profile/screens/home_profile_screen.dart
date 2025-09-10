import 'package:fakhama_amir_app/core/class/statusrequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../auth/models/user_model.dart';
import '../../widgets/appbar_widget.dart';
import '../cntrollers/profile_cntroller.dart';

class HomeProfileScreen extends GetView<ProfileCntroller> {
  const HomeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: 'الملف الشخصي',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Obx(() {
        if (controller.statusRequest.value.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.userModel.value;
        if (user == null) {
          return const Center(
            child: Text('لا توجد بيانات المستخدم'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getMyData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Profile Header Card
                _buildProfileHeader(user),
                SizedBox(height: 20.h),

                // Personal Information Card
                _buildPersonalInfoCard(user),
                SizedBox(height: 16.h),

                // Location Information Card
                // _buildLocationCard(user),
                // SizedBox(height: 16.h),

                // Financial Summary Card
                if (user.financialSummary != null ||
                    user.totalOrders != null ||
                    user.totalAmount != null)
                  _buildFinancialCard(user),

                if (user.financialSummary != null ||
                    user.totalOrders != null ||
                    user.totalAmount != null)
                  SizedBox(height: 20.h),

                // Logout Button
                _buildLogoutButton(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 40.sp,
              color: Colors.blue.shade600,
            ),
          ),
          SizedBox(height: 12.h),

          // Full Name
          Text(
            user.fullName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),

          // Username
          if (user.username.isNotEmpty)
            Text(
              '@${user.username}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14.sp,
              ),
            ),
          SizedBox(height: 8.h),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: user.isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              user.isActive ? 'نشط' : 'غير نشط',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(UserModel user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المعلومات الشخصية',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16.h),
            _buildInfoRow(
              icon: Icons.email_outlined,
              label: 'البريد الإلكتروني',
              value: user.email.isEmpty ? 'غير محدد' : user.email,
              color: Colors.blue,
            ),
            SizedBox(height: 12.h),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: 'رقم الهاتف',
              value: user.phone,
              color: Colors.green,
            ),
            if (user.createdAt != null) ...[
              SizedBox(height: 12.h),
              _buildInfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'تاريخ التسجيل',
                value: _formatDate(user.createdAt!),
                color: Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(UserModel user) {
    if (user.city == null &&
        user.country == null &&
        user.streetAddress == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الموقع',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16.h),
            if (user.country != null)
              _buildInfoRow(
                icon: Icons.flag_outlined,
                label: 'الدولة',
                value: user.country!,
                color: Colors.red,
              ),
            if (user.city != null) ...[
              if (user.country != null) SizedBox(height: 12.h),
              _buildInfoRow(
                icon: Icons.location_city_outlined,
                label: 'المدينة',
                value: user.city!,
                color: Colors.purple,
              ),
            ],
            if (user.streetAddress != null) ...[
              if (user.city != null || user.country != null)
                SizedBox(height: 12.h),
              _buildInfoRow(
                icon: Icons.home_outlined,
                label: 'العنوان',
                value: user.streetAddress!,
                color: Colors.teal,
              ),
            ],
            if (user.latitude != null && user.longitude != null) ...[
              SizedBox(height: 12.h),
              _buildInfoRow(
                icon: Icons.my_location_outlined,
                label: 'الإحداثيات',
                value:
                    '${user.latitude!.toStringAsFixed(6)}, ${user.longitude!.toStringAsFixed(6)}',
                color: Colors.indigo,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(UserModel user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الملخص المالي',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16.h),

            if (user.totalOrders != null)
              _buildFinancialRow(
                icon: Icons.shopping_cart_outlined,
                label: 'إجمالي الطلبات',
                value: user.totalOrders!.toString(),
                color: Colors.blue,
              ),

            if (user.totalAmount != null) ...[
              SizedBox(height: 12.h),
              _buildFinancialRow(
                icon: Icons.account_balance_wallet_outlined,
                label: 'إجمالي المبلغ',
                value: McProcess.formatNumber(user.totalAmount!.toString()),
                color: Colors.green,
              ),
            ],

            if (user.totalPaid != null) ...[
              SizedBox(height: 12.h),
              _buildFinancialRow(
                icon: Icons.payment_outlined,
                label: 'المبلغ المدفوع',
                value: McProcess.formatNumber(user.totalPaid!.toString()),
                color: Colors.teal,
              ),
            ],

            if (user.remainingAmount != null) ...[
              SizedBox(height: 12.h),
              _buildFinancialRow(
                icon: Icons.pending_actions_outlined,
                label: 'المبلغ المتبقي',
                value: McProcess.formatNumber(user.remainingAmount!.toString()),
                color: user.remainingAmount! > 0 ? Colors.orange : Colors.green,
              ),
            ],

            // Financial Summary Details
            if (user.financialSummary != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل إضافية',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Add financial summary details here if FinancialSummary model has specific fields
                    Text(
                      'تم تحميل الملخص المالي بنجاح',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
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
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
