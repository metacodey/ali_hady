import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/orders/models/order_model.dart';
import 'package:fakhama_amiradmin_app/features/payments/controllers/add_edit_payment_controler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/utils/widgets/drop_down.dart';

class OrderSelectionCard extends GetView<AddEditPaymentControler> {
  const OrderSelectionCard({super.key});

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
                  Icons.receipt_long_outlined,
                  color: Colors.blue[700],
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'اختيار الطلب',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Order Selection Dropdown
            Obx(() {
              return controller.statusLoadOrders.value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : DropDown<OrderModel>(
                      list: controller.ordersIncomplete,
                      title: "اختر الطلب",
                      isSearch: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      radius: 10.r,
                      model: controller.selectedOrder.value,
                      onChange: controller.selectOrder,
                      // enabled: !controller.isEditMode, // تعطيل في حالة التعديل
                    );
            }),

            // Order Details
            Obx(() {
              if (controller.selectedOrder.value != null) {
                final order = controller.selectedOrder.value!;
                return Container(
                  margin: EdgeInsets.only(top: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفاصيل الطلب',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow('العميل:', order.customerName),
                      _buildDetailRow('المبلغ الإجمالي:',
                          '${McProcess.formatNumber(order.totalAmount.toStringAsFixed(2))} ر.س'),
                      _buildDetailRow('المبلغ المدفوع:',
                          '${McProcess.formatNumber(order.paidAmount.toStringAsFixed(2))} ر.س'),
                      _buildDetailRow('المبلغ المتبقي:',
                          '${McProcess.formatNumber(order.remainingAmount.toStringAsFixed(2))} ر.س',
                          isHighlight: true),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? Colors.green[700] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
