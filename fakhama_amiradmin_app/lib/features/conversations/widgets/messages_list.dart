import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../controllers/chat_controller.dart';
import 'message_bubble.dart';

class MessagesList extends GetView<ChatController> {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.statusRequest.value.isLoading &&
          controller.messages.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF007AFF),
          ),
        );
      }

      if (controller.statusRequest.value.isError &&
          controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48.sp,
                color: const Color(0xFF8E8E93),
              ),
              SizedBox(height: 12.h),
              Text(
                'حدث خطأ في تحميل الرسائل',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: controller.loadMessages,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 48.sp,
                color: const Color(0xFF8E8E93),
              ),
              SizedBox(height: 12.h),
              Text(
                'لا توجد رسائل',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'ابدأ المحادثة بإرسال رسالة',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFFAEAEB2),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        color: Colors.white,
        child: ListView.builder(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: controller.messages.length +
              (controller.hasMoreMessages.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0 && controller.hasMoreMessages.value) {
              return Container(
                padding: EdgeInsets.all(12.w),
                child: Center(
                  child: controller.isLoadingMore.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF007AFF),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              );
            }

            final messageIndex =
                controller.hasMoreMessages.value ? index - 1 : index;

            if (messageIndex < 0 ||
                messageIndex >= controller.messages.length) {
              return const SizedBox.shrink();
            }

            final message = controller.messages[messageIndex];
            if (message.isFromCustomer) {
              controller.markMessageAsRead(message);
            }
            return MessageBubble(
              message: message,
              onTap: () {
                // تحديد الرسائل كمقروءة فقط إذا كانت من العملاء وغير مقروءة
                if (!message.isRead && message.isFromCustomer) {
                  controller.markMessageAsRead(message);
                }
              },
            );
          },
        ),
      );
    });
  }
}
