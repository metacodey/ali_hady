import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/add_edit_orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/products/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/utils/widgets/drop_down.dart';

class OrderProductsCard extends GetView<AddEditOrdersController> {
  const OrderProductsCard({super.key});

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
                  Icons.shopping_cart_outlined,
                  color: Colors.green[700],
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'منتجات الطلب',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Obx(() => Text(
                      'المجموع: ${McProcess.formatNumber(controller.totalAmount.value.toStringAsFixed(2))}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    )),
              ],
            ),

            SizedBox(height: 16.h),

            // Add Product Section
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إضافة منتج جديد',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() {
                    return controller.statusLoadProducts.value.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          )
                        : DropDown<ProductModel>(
                            list: controller.products,
                            title: "اختر المنتج",
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 8.h),
                            radius: 8.r,
                            isSearch: true,
                            model: null,
                            onChange: (product) {
                              if (product != null) {
                                controller.addProductToOrder(product);
                              }
                            },
                          );
                  }),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Order Items List
            Obx(() {
              if (controller.orderItems.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'لم يتم إضافة أي منتجات بعد',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'اختر منتج من القائمة أعلاه لإضافته',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.orderItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final orderItem = controller.orderItems[index];
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        // Product Info
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderItem.product.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'السعر: ${McProcess.formatNumber(orderItem.product.price.toString())}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green[600],
                                ),
                              ),
                              if (orderItem.product.sku.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  'الكود: ${orderItem.product.sku}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Quantity Controls
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Obx(() => ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 70.w,
                                        ),
                                        child: McText(
                                          txt:
                                              '${McProcess.formatNumber((orderItem.product.price * orderItem.quantity.value).toStringAsFixed(2))} ',
                                          fontSize: 13.sp,
                                          blod: true,
                                          color: Colors.blue[700],
                                        ),
                                      )),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  McCardItem(
                                    showShdow: false,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    margin: EdgeInsets.zero,
                                    radius: BorderRadius.circular(5),
                                    colorBorder: Colors.red[300]!,
                                    onTap: () {
                                      controller.removeProductFromOrder(index);
                                    },
                                    color: Colors.red[50]!,
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 16.sp,
                                      color: Colors.red[600],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  McCardItem(
                                    showShdow: false,
                                    padding: EdgeInsets.all(4.w),
                                    margin: EdgeInsets.zero,
                                    colorBorder: Colors.red[300]!,
                                    onTap: () {
                                      if (orderItem.quantity.value > 1) {
                                        controller.updateProductQuantity(index,
                                            orderItem.quantity.value - 1);
                                      }
                                    },
                                    color: Colors.red[50]!,
                                    child: Icon(
                                      Icons.remove,
                                      size: 16.sp,
                                      color: Colors.red[600],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Obx(() => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          orderItem.quantity.value.toString(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                  SizedBox(width: 8.w),
                                  McCardItem(
                                    showShdow: false,
                                    padding: EdgeInsets.all(4.w),
                                    margin: EdgeInsets.zero,
                                    colorBorder: Colors.green[300]!,
                                    onTap: () {
                                      controller.updateProductQuantity(
                                          index, orderItem.quantity.value + 1);
                                    },
                                    color: Colors.green[50]!,
                                    child: Icon(
                                      Icons.add,
                                      size: 16.sp,
                                      color: Colors.green[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            SizedBox(
              height: 10.h,
            ),
            // Customer Notes Field
            CustomTextField(
              controller: controller.customerNotesController,
              label: 'ملاحظات العميل',
              hintText: 'أدخل أي ملاحظات خاصة بالطلب...',
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
