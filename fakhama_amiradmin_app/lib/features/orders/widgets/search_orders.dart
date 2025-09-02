import 'package:fakhama_amiradmin_app/features/orders/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/utils/widgets/custom_text_field.dart';
import '../../../core/constants/utils/widgets/drop_down.dart';
import '../controllers/orders_controller.dart';

class SearchOrders extends GetView<OrdersController> {
  const SearchOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: controller.searchController,
          hintText: "البحث في الطلبات (رقم الطلب، اسم العميل، رقم الهاتف...)",
          focusNode: controller.searchFocus,
          prefixIcon: Icon(
            Icons.search,
            size: 24.sp,
            color: Theme.of(context).dividerColor,
          ),
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          padding: EdgeInsets.all(12.r),
          radius: BorderRadius.circular(8.r),
          borderSide:
              const BorderSide(color: AppColors.greenBlueVeryLight, width: 2),
          keyboardType: TextInputType.text,
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.setSearchQuery('');
                  },
                )
              : const SizedBox()),
          onChanged: controller.setSearchQuery,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return DropDown<StatusModel>(
                  list: controller.statusOrder,
                  title: "اختر الحالة",
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  radius: 5.r,
                  model: controller.selectedStatus.value,
                  onChange: controller.setStatus,
                );
              }),
            ),
            SizedBox(width: 10.w),
            McCardItem(
              showShdow: false,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              margin: EdgeInsets.zero,
              colorBorder: AppColors.greenBlueVeryLight,
              onTap: controller.resetFilters,
              color: Theme.of(context).focusColor,
              child: Icon(Icons.refresh,
                  size: 20.sp, color: Theme.of(context).dividerColor),
            ),
          ],
        ),
      ],
    );
  }
}
