import 'package:fakhama_amiradmin_app/features/products/controllers/add_edit_product_controller.dart';
import 'package:fakhama_amiradmin_app/features/products/widgets/add_edit/basic_info_card.dart';
import 'package:fakhama_amiradmin_app/features/products/widgets/add_edit/save_button.dart';
import 'package:fakhama_amiradmin_app/features/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class AddEditProductScreen extends GetView<AddEditProductController> {
  const AddEditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: controller.isEditMode.value ? 'تعديل المنتج' : 'إضافة منتج جديد',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Basic Information Card
              const BasicInfoCard(),

              SizedBox(height: 24.h),

              // Save Button
              const SaveButton(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
