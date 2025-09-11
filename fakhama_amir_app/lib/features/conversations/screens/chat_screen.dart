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
      body: const Column(
        children: [
          // قائمة الرسائل
          Expanded(
            child: MessagesList(),
          ),

          // حقل إرسال الرسالة
          MessageInput(),
        ],
      ),
    );
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
                ? controller.updateConversationStatusToClosed
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
