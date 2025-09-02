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
            // Card Title
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.blue,
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

            // Username Field
            CustomTextField(
              controller: controller.usernameController,
              label: 'اسم المستخدم',
              hintText: 'أدخل اسم المستخدم',
              prefixIcon: Icon(Icons.account_circle_outlined),
              validator: controller.validateUsername,
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // Full Name Field
            CustomTextField(
              controller: controller.fullNameController,
              label: 'الاسم الكامل',
              hintText: 'أدخل الاسم الكامل',
              prefixIcon: Icon(Icons.person),
              validator: controller.validateFullName,
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // Email Field
            CustomTextField(
              controller: controller.emailController,
              label: 'البريد الإلكتروني',
              hintText: 'أدخل البريد الإلكتروني',
              prefixIcon: Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // Password Field
            Obx(() => CustomTextField(
                  controller: controller.passwordController,
                  label: controller.isEditMode.value
                      ? 'كلمة المرور (اختياري)'
                      : 'كلمة المرور',
                  hintText: controller.isEditMode.value
                      ? 'اتركه فارغاً للاحتفاظ بكلمة المرور الحالية'
                      : 'أدخل كلمة المرور',
                  prefixIcon: Icon(Icons.lock_outline),
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: controller.validatePassword,
                  isNext: true,
                )),

            SizedBox(height: 16.h),

            // Phone Field
            CustomTextField(
              controller: controller.phoneController,
              label: 'رقم الهاتف',
              hintText: 'أدخل رقم الهاتف',
              prefixIcon: Icon(Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              validator: controller.validatePhone,
              isNext: true,
            ),

            SizedBox(height: 16.h),

            // Active Status Switch
            Obx(() => SwitchListTile(
                  title: Text(
                    'حالة العميل',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    controller.isActive.value ? 'نشط' : 'غير نشط',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          controller.isActive.value ? Colors.green : Colors.red,
                    ),
                  ),
                  value: controller.isActive.value,
                  onChanged: (value) => controller.toggleActiveStatus(),
                  activeColor: Colors.green,
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
      ),
    );
  }
}
