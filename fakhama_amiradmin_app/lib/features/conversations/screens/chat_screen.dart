import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../widgets/appbar_widget.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_input.dart';
import '../widgets/messages_list.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() {
        // التحقق من حالة المحادثة
        if (controller.conversation.value?.status == 'pending') {
          return _buildPendingRequestView();
        }

        return const Column(
          children: [
            // قائمة الرسائل
            Expanded(
              child: MessagesList(),
            ),
            // حقل إرسال الرسالة
            MessageInput(),
          ],
        );
      }),
    );
  }

  // ويدجت عرض الطلب المعلق
  Widget _buildPendingRequestView() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions,
            size: 80.sp,
            color: Colors.orange,
          ),
          SizedBox(height: 20.h),
          Text(
            'طلب محادثة معلق',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'يوجد طلب محادثة من العميل ${controller.conversation.value?.customerName ?? "غير محدد"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'الموضوع: ${controller.conversation.value?.subject ?? "غير محدد"}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 40.h),
          Row(
            children: [
              // زر الرفض
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showRejectDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'رفض الطلب',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // زر القبول
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'قبول الطلب',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // دالة قبول الطلب
  void _acceptRequest() {
    final conversationId = controller.conversation.value?.id;
    if (conversationId != null) {
      // الحصول على ConversationController
      controller.updateConversationStatus("open");
    }
  }

  // دالة إظهار حوار تأكيد الرفض
  void _showRejectDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الرفض'),
        content: const Text(
            'هل أنت متأكد من رفض هذا الطلب؟\nلن يتمكن العميل من التواصل معك.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _rejectRequest();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }

  // دالة رفض الطلب
  void _rejectRequest() {
    final conversationId = controller.conversation.value?.id;
    if (conversationId != null) {
      controller.updateConversationStatus("closed");
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppbarWidget(
      title: controller.conversation.value?.subject,
      appBarWidth: 20.w,
      showWidget: true,
      children: [
        // زر إغلاق المحادثة (تحديث الحالة)
        Obx(() {
          var status = controller.conversation.value?.status;
          return IconButton(
            onPressed: status == 'open'
                ? () => controller.updateConversationStatus('closed')
                : null,
            icon: Icon(
              Icons.lock,
              size: 24.sp,
              color: status != 'open' ? Colors.grey : Colors.red,
            ),
            tooltip: status != 'open' ? 'المحادثة مغلقة' : 'إغلاق المحادثة',
          );
        }),

        // زر إغلاق المحادثة (الخروج)
        IconButton(
          onPressed: controller.closeConversation,
          icon: Icon(
            Icons.close,
            size: 24.sp,
          ),
          tooltip: 'إغلاق المحادثة',
        ),
      ],
    );
  }
}
