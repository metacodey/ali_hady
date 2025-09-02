import 'package:fakhama_amiradmin_app/features/clients/controllers/add_edit_client_controller.dart';
import 'package:fakhama_amiradmin_app/features/clients/widgets/add_edit/basic_info_card.dart';
import 'package:fakhama_amiradmin_app/features/clients/widgets/add_edit/location_info_card.dart';
import 'package:fakhama_amiradmin_app/features/clients/widgets/add_edit/save_button.dart';
import 'package:fakhama_amiradmin_app/features/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class AddEditClientScreen extends GetView<AddEditClientController> {
  const AddEditClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: controller.isEditMode.value ? 'تعديل العميل' : 'إضافة عميل جديد',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Basic Information Card
              const BasicInfoCard(),

              SizedBox(height: 16.h),

              // Location Information Card
              const LocationInfoCard(),

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
