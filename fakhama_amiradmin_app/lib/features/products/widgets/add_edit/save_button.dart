import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/products/controllers/add_edit_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class SaveButton extends GetView<AddEditProductController> {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: controller.statusRequest.value.isLoading
                ? null
                : controller.saveProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
            ),
            child: controller.statusRequest.value.isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.isEditMode.value ? Icons.update : Icons.save,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        controller.isEditMode.value
                            ? 'تحديث المنتج'
                            : 'حفظ المنتج',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
