import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/payments/controllers/add_edit_payment_controler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/utils/widgets/drop_down.dart';

class PaymentDetailsCard extends GetView<AddEditPaymentControler> {
  const PaymentDetailsCard({super.key});

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
                  Icons.payment_outlined,
                  color: Colors.green[700],
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'تفاصيل الدفعة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Amount Field
            CustomTextField(
              controller: controller.amountController,
              label: 'مبلغ الدفعة',
              hintText: 'أدخل مبلغ الدفعة',
              prefixIcon: Icon(Icons.attach_money_outlined, color: Colors.green[600]),
              keyboardType: TextInputType.number,
              paddingLable: EdgeInsets.symmetric(vertical: 5.h),
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            
            SizedBox(height: 16.h),

            // Payment Method Selection
            Text(
              'طريقة الدفع',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() => DropDown<String>(
              list: controller.paymentMethods,
              title: "اختر طريقة الدفع",
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              radius: 10.r,
              model: controller.selectedPaymentMethod.value,
              onChange: (method) {
                if (method != null) {
                  controller.setPaymentMethod(method);
                }
              },
            )),
            
            SizedBox(height: 16.h),

            // Notes Field
            CustomTextField(
              controller: controller.notesController,
              label: 'ملاحظات الدفعة',
              hintText: 'أدخل أي ملاحظات خاصة بالدفعة...',
              prefixIcon: Icon(Icons.note_outlined, color: Colors.purple[600]),
              maxline: 3,
              paddingLable: EdgeInsets.symmetric(vertical: 5.h),
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}