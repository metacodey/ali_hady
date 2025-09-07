import 'package:fakhama_amiradmin_app/features/payments/controllers/add_edit_payment_controler.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/order_selection_card.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/payment_details_card.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/save_payment_button.dart';
import 'package:fakhama_amiradmin_app/features/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class AddEditPaymentScreen extends GetView<AddEditPaymentControler> {
  const AddEditPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: controller.isEditMode ? 'تعديل الدفعة' : 'إضافة دفعة جديدة',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Order Selection Card
              const OrderSelectionCard(),

              SizedBox(height: 16.h),

              // Payment Details Card
              const PaymentDetailsCard(),

              SizedBox(height: 24.h),

              // Save Button
              const SavePaymentButton(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}