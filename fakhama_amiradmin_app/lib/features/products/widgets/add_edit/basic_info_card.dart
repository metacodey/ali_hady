import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/products/controllers/add_edit_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../../core/constants/colors.dart';

class BasicInfoCard extends GetView<AddEditProductController> {
  const BasicInfoCard({super.key});

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
            // Card Title - لون معلومات عامة (أزرق)
            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.blue[700], // أزرق للمعلومات العامة
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'المعلومات الأساسية',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Product Name Field - لون للمنتج (أخضر)
            CustomTextField(
              controller: controller.nameController,
              label: 'اسم المنتج',
              hintText: 'أدخل اسم المنتج',
              prefixIcon: Icon(Icons.shopping_bag_outlined,
                  color: Colors.green[600]), // أخضر للمنتج
              validator: controller.validateName,
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              paddingLable: EdgeInsets.symmetric(vertical: 5.h),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // Product Description Field - لون للوصف (برتقالي)
            CustomTextField(
              controller: controller.descriptionController,
              label: 'وصف المنتج',
              hintText: 'أدخل وصف المنتج',
              prefixIcon: Icon(Icons.description_outlined,
                  color: Colors.orange[600]), // برتقالي للوصف
              maxline: 3,
              paddingLable: EdgeInsets.symmetric(vertical: 5.h),
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // SKU Field with Auto-Generate Button - لون للكود (أرجواني)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                McText(
                  txt: "رمز المنتج (SKU)",
                  blod: true,
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: controller.skuController,
                        hintText: 'رمز المنتج',
                        prefixIcon: Icon(Icons.qr_code_outlined,
                            color: Colors.purple[600]), // أرجواني للكود
                        validator: controller.validateSKU,
                        radius: BorderRadius.circular(10.r),
                        fillColor: Get.theme.canvasColor,
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.2,
                        ),
                        isNext: true,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    McCardItem(
                      showShdow: false,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      margin: EdgeInsets.zero,
                      colorBorder: AppColors.greenBlueVeryLight,
                      onTap: controller.regenerateSKU,
                      color: Theme.of(context).focusColor,
                      child: Icon(Icons.refresh,
                          size: 20.sp, color: Theme.of(context).dividerColor),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Price and Quantity Row
            Row(
              children: [
                // Price Field - لون للسعر (أخضر مالي)
                Expanded(
                  child: CustomTextField(
                    controller: controller.priceController,
                    label: 'السعر',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money,
                        color: Colors.green[700]), // أخضر للسعر
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: controller.validatePrice,
                    paddingLable: EdgeInsets.symmetric(vertical: 5.h),
                    radius: BorderRadius.circular(10.r),
                    fillColor: Get.theme.canvasColor,
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.2,
                    ),
                    isNext: true,
                  ),
                ),
                SizedBox(width: 12.w),
                // Quantity Field - لون للكمية (أزرق للمخزون)
                Expanded(
                  child: CustomTextField(
                    controller: controller.quantityController,
                    label: 'الكمية',
                    hintText: '0',
                    prefixIcon: Icon(Icons.inventory_outlined,
                        color: Colors.blue[600]), // أزرق للكمية
                    keyboardType: TextInputType.number,
                    paddingLable: EdgeInsets.symmetric(vertical: 5.h),
                    radius: BorderRadius.circular(10.r),
                    fillColor: Get.theme.canvasColor,
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.2,
                    ),
                    isNext: true,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
