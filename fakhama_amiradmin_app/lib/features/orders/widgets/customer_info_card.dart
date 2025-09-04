import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/add_edit_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/utils/widgets/drop_down.dart';

class CustomerInfoCard extends GetView<AddEditOrdersController> {
  const CustomerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Title
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.blue[700],
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'معلومات العميل',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Customer Selection Dropdown
            Obx(() {
              return controller.statusLoadCustomers.value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : DropDown<UserModel>(
                      list: controller.customers,
                      title: "اختر العميل",
                      isSearch: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      radius: 10.r,
                      model: controller.selectedCustomer.value,
                      onChange: controller.selectCustomer,
                    );
            }),
          ],
        ),
      ),
    );
  }
}
