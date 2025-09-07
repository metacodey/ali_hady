import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/payments/controllers/payment_controller.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/list_payments.dart';
import 'package:fakhama_amiradmin_app/features/payments/widgets/search_payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/refresh_empty_widget.dart';

class HomePaymentsScreen extends GetView<PaymentController> {
  const HomePaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: "الدفعات",
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: const SearchPayments()),
          _buildPaginationInfo(),
          Expanded(
            child: Obx(
              () {
                if (controller.statusRequest.value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!controller.statusRequest.value.isSuccess) {
                  return RefreshEmptyWidget(
                    onRefresh: controller.fetchData,
                    emptyText: controller.statusRequest.value.text,
                    icon: controller.statusRequest.value.icon,
                    controller: controller.scroller,
                  );
                }
                if (controller.filteredPayments.isEmpty &&
                    !controller.statusRequest.value.isLoading) {
                  return RefreshEmptyWidget(
                    onRefresh: controller.fetchData,
                    emptyText: "لا توجد دفعات",
                    value: "لم يتم العثور على أي دفعات",
                    icon: Icons.payment_outlined,
                    controller: controller.scroller,
                  );
                }
                return const ListPayments();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "HomePaymentsScreen",
        onPressed: () => Get.toNamed('/payments/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPaginationInfo() {
    return Obx(() {
      if (controller.totalItems.value == 0) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'عرض ${controller.payments.length} من ${controller.totalItems.value}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            if (controller.hasMoreData.value)
              Text(
                'الصفحة ${controller.currentPage.value} من ${controller.totalPages.value}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      );
    });
  }
}
