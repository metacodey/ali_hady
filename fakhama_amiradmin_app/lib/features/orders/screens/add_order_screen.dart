import 'package:fakhama_amiradmin_app/features/orders/controllers/add_edit_orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/customer_info_card.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/order_products_card.dart';
import 'package:fakhama_amiradmin_app/features/orders/widgets/save_order_button.dart';
import 'package:fakhama_amiradmin_app/features/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

class AddOrderScreen extends GetView<AddEditOrdersController> {
  const AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: 'إضافة طلب جديد',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Customer Information Card
              const CustomerInfoCard(),

              SizedBox(height: 16.h),

              // Order Products Card
              const OrderProductsCard(),

              SizedBox(height: 24.h),

              // Save Button
              const SaveOrderButton(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}