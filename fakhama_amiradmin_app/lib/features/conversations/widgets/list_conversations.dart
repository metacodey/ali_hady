import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../controllers/conversation_controller.dart';
import 'item_conversation.dart';

class ListConversations extends GetView<ConversationController> {
  const ListConversations({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: controller.fetchData,
        child: Obx(() {
          var conversations = controller.filteredConversations;
          var length =
              conversations.length + (controller.hasMoreData.value ? 1 : 0);

          return ListView.builder(
              controller: controller.scroller,
              itemCount: length,
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              itemBuilder: (context, index) {
                if (index == (length) - 1 && controller.hasMoreData.value) {
                  return _buildLoadMoreIndicator();
                }
                if (index >= conversations.length) {
                  return const SizedBox.shrink();
                }
                var conversation = controller.filteredConversations[index];
                return ItemConversation(
                  conversation: conversation,
                  onTap: () {
                    _navigateToChat(context, conversation);
                  },
                );
              });
        }));
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (!controller.hasMoreData.value) {
        return Container(
          padding: EdgeInsets.all(16.r),
          child: Center(
            child: Text(
              'تم عرض جميع المحادثات',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }

      // التحميل التلقائي فقط
      return const SizedBox.shrink();
    });
  }

  void _navigateToChat(BuildContext context, conversation) {
    Get.toNamed(
      '/chat/chat',
      arguments:
          conversation, // تمرير كائن المحادثة مباشرة كما يتوقعه ChatController
    );
  }
}
