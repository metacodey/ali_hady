import 'package:fakhama_amir_app/core/class/statusrequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../widgets/appbar_widget.dart';
import '../../widgets/refresh_empty_widget.dart';
import '../controllers/conversation_controller.dart';
import '../widgets/list_conversations.dart';
import '../widgets/search_conversations.dart';

class HomeConversationsScreen extends GetView<ConversationController> {
  const HomeConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: "المحادثات",
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: const SearchConversations()),
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
                if (controller.filteredConversations.isEmpty &&
                    !controller.statusRequest.value.isLoading) {
                  return RefreshEmptyWidget(
                    onRefresh: controller.fetchData,
                    emptyText: "لا توجد محادثات",
                    value: "لم يتم العثور على أي محادثات",
                    icon: Icons.chat_outlined,
                    controller: controller.scroller,
                  );
                }
                return const ListConversations();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "HomeChatScreen",
        onPressed: () => Get.toNamed('/chat/add'),
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
              'عرض ${controller.conversations.length} من ${controller.totalItems.value}',
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
