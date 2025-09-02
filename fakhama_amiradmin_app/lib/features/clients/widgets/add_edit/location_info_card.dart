import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/clients/controllers/add_edit_client_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class LocationInfoCard extends GetView<AddEditClientController> {
  const LocationInfoCard({super.key});

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
            // Card Title - لون الموقع (برتقالي/أحمر)
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.orange[700], // برتقالي للموقع
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'معلومات الموقع',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            if (!controller.isEditMode.value) ...[
              // Country Field - لون العلم (أخضر للدولة)
              CustomTextField(
                controller: controller.countryController,
                label: 'الدولة',
                hintText: 'أدخل اسم الدولة',
                prefixIcon: Icon(Icons.flag_outlined,
                    color: Colors.green[600]), // أخضر للدولة
                validator: (value) =>
                    controller.validateRequired(value, 'الدولة'),
                isNext: true,
                radius: BorderRadius.circular(10.r),
                fillColor: Get.theme.canvasColor,
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.2,
                ),
              ),

              SizedBox(height: 16.h),
            ],

            // City Field - لون المدينة (أزرق للمدينة)
            CustomTextField(
              controller: controller.cityController,
              label: 'المدينة',
              hintText: 'أدخل اسم المدينة',
              prefixIcon: Icon(Icons.location_city_outlined,
                  color: Colors.blue[600]), // أزرق للمدينة
              isNext: true,
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),

            SizedBox(height: 16.h),

            // Street Address Field - لون العنوان (بني للعنوان)
            CustomTextField(
              controller: controller.streetAddressController,
              label: 'عنوان الشارع',
              hintText: 'أدخل عنوان الشارع',
              prefixIcon: Icon(Icons.home_outlined,
                  color: Colors.brown[600]), // بني للعنوان
              maxline: 2,
              isNext: true,
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),

            SizedBox(height: 16.h),

            if (!controller.isEditMode.value) ...[
              // Coordinates Section
              Text(
                'الإحداثيات (اختياري)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),

              SizedBox(height: 8.h),

              Row(
                children: [
                  // Latitude Field - لون خط العرض (أحمر للاتجاه الشمالي)
                  Expanded(
                    child: CustomTextField(
                      controller: controller.latitudeController,
                      label: 'خط العرض',
                      hintText: '21.5428',
                      prefixIcon: Icon(Icons.my_location,
                          color: Colors.red[600]), // أحمر لخط العرض
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: controller.validateLatitude,
                      isNext: true,
                      radius: BorderRadius.circular(10.r),
                      fillColor: Get.theme.canvasColor,
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Longitude Field - لون خط الطول (أزرق للاتجاه الشرقي)
                  Expanded(
                    child: CustomTextField(
                      controller: controller.longitudeController,
                      label: 'خط الطول',
                      hintText: '39.1728',
                      prefixIcon: Icon(Icons.place,
                          color: Colors.blue[600]), // أزرق لخط الطول
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: controller.validateLongitude,
                      radius: BorderRadius.circular(10.r),
                      fillColor: Get.theme.canvasColor,
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
