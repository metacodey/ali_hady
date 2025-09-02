import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/custom_text_field.dart';
import 'package:fakhama_amiradmin_app/features/clients/controllers/add_edit_client_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class BasicInfoCard extends GetView<AddEditClientController> {
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
            // Card Title - لون معلومات العميل (أزرق)
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.blue[700], // أزرق للمعلومات الشخصية
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

            // Full Name Field - لون للاسم (أرجواني للهوية الشخصية)
            CustomTextField(
              controller: controller.fullNameController,
              label: 'الاسم الكامل',
              hintText: 'أدخل الاسم الكامل',
              prefixIcon: Icon(Icons.person,
                  color: Colors.purple[600]), // أرجواني للهوية
              validator: controller.validateFullName,
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
              isNext: true,
            ),

            SizedBox(height: 16.h),

            if (!controller.isEditMode.value) ...[
              // Email Field - لون للإيميل (أحمر/برتقالي للاتصالات)
              CustomTextField(
                controller: controller.emailController,
                label: 'البريد الإلكتروني',
                hintText: 'أدخل البريد الإلكتروني',
                prefixIcon: Icon(Icons.email_outlined,
                    color: Colors.red[600]), // أحمر للإيميل
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
                radius: BorderRadius.circular(10.r),
                fillColor: Get.theme.canvasColor,
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.2,
                ),
                isNext: true,
              ),

              SizedBox(height: 16.h),

              // Password Field - لون للأمان (أحمر/برتقالي للأمان)
              Obx(() => CustomTextField(
                    controller: controller.passwordController,
                    label: controller.isEditMode.value
                        ? 'كلمة المرور (اختياري)'
                        : 'كلمة المرور',
                    hintText: controller.isEditMode.value
                        ? 'اتركه فارغاً للاحتفاظ بكلمة المرور الحالية'
                        : 'أدخل كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: Colors.orange[600]), // برتقالي للأمان
                    obscureText: !controller.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[600], // رمادي لأيقونة الرؤية
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    validator: controller.validatePassword,
                    isNext: true,
                    radius: BorderRadius.circular(10.r),
                    fillColor: Get.theme.canvasColor,
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.2,
                    ),
                  )),

              SizedBox(height: 16.h),
            ],

            // Phone Field - لون للهاتف (أخضر للاتصالات)
            CustomTextField(
              controller: controller.phoneController,
              label: 'رقم الهاتف',
              hintText: 'أدخل رقم الهاتف',
              prefixIcon: Icon(Icons.phone_outlined,
                  color: Colors.green[600]), // أخضر للهاتف
              keyboardType: TextInputType.phone,
              validator: controller.validatePhone,
              isNext: true,
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),

            SizedBox(height: 16.h),

            // // Active Status Switch
            // Obx(() => SwitchListTile(
            //       title: Text(
            //         'حالة العميل',
            //         style: TextStyle(
            //           fontSize: 14.sp,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       subtitle: Text(
            //         controller.isActive.value ? 'نشط' : 'غير نشط',
            //         style: TextStyle(
            //           fontSize: 12.sp,
            //           color:
            //               controller.isActive.value ? Colors.green : Colors.red,
            //         ),
            //       ),
            //       value: controller.isActive.value,
            //       onChanged: (value) => controller.toggleActiveStatus(),
            //       activeColor: Colors.green,
            //       contentPadding: EdgeInsets.zero,
            //     )),
          ],
        ),
      ),
    );
  }
}
