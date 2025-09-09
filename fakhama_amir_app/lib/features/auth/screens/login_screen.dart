import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/validate_types.dart';
import '../../../core/functions/validinput.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.r),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(22.r),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.admin_panel_settings,
                        size: 64.r, color: Colors.blue),
                    16.h.verticalSpace,
                    Text(
                      "login".tr,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    24.h.verticalSpace,

                    // Email
                    TextFormField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "email".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (p0) => validInput(
                          val: p0 ?? "",
                          min: 3,
                          max: 100,
                          name: "email",
                          type: ValidateTypes.email),
                    ),
                    12.h.verticalSpace,

                    // Password
                    Obx(() {
                      return TextFormField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "password".tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18.r,
                              color: Theme.of(context).hintColor,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        validator: (p0) => validInput(
                            val: p0 ?? "",
                            min: 3,
                            max: 100,
                            name: "password",
                            type: ValidateTypes.password),
                      );
                    }),
                    16.h.verticalSpace,

                    // Button
                    ElevatedButton(
                      onPressed: controller.signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 12.h),
                      ),
                      child:
                          Text("login".tr, style: TextStyle(fontSize: 16.sp)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
