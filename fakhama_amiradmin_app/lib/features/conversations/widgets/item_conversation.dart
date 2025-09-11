import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/conversation_model.dart';

class ItemConversation extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemConversation({
    super.key,
    required this.conversation,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 2.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: conversation.hasUnreadMessages
                  ? Colors.blue.shade50
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: conversation.hasUnreadMessages
                  ? Border.all(color: Colors.blue.shade200, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                // Profile/Chat Icon
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: _getStatusColor().withOpacity(0.2),
                  child: Icon(
                    Icons.chat,
                    color: _getStatusColor(),
                    size: 18.sp,
                  ),
                ),

                SizedBox(width: 12.w),

                // Conversation Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Time
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.subject,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: conversation.hasUnreadMessages
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            conversation.formattedDate,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Last Message
                      if (conversation.lastMessage.isNotEmpty)
                        Text(
                          conversation.lastMessage,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Assigned User
                      if (conversation.assignedUser != null)
                        Text(
                          conversation.assignedUser!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Status and Unread Badge
                Column(
                  children: [
                    // Status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        conversation.statusInArabic,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),

                    // Unread Badge
                    if (conversation.hasUnreadMessages)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '${conversation.unreadMessages}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (conversation.status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
