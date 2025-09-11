import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onTap;

  const MessageBubble({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFromMe = message.isFromCustomer;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 2.h,
        ),
        child: Row(
          mainAxisAlignment:
              isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isFromMe) ...[
              _buildAvatar(false),
              SizedBox(width: 6.w),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isFromMe
                      ? const Color(0xFF007AFF)
                      : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft:
                        isFromMe ? Radius.circular(18.r) : Radius.circular(4.r),
                    bottomRight:
                        isFromMe ? Radius.circular(4.r) : Radius.circular(18.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isFromMe) ...[
                      Text(
                        message.senderName,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF007AFF),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                    Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            isFromMe ? Colors.white : const Color(0xFF1C1C1E),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isFromMe
                                ? Colors.white.withOpacity(0.8)
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                        if (isFromMe) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.done,
                            size: 12.sp,
                            color: message.isRead
                                ? Colors.white
                                : Colors.white.withOpacity(0.8),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isFromMe) ...[
              SizedBox(width: 6.w),
              _buildAvatar(true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isMe) {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF007AFF) : const Color(0xFF8E8E93),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isMe ? Icons.person : Icons.support_agent,
        color: Colors.white,
        size: 16.sp,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'أمس ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('dd/MM HH:mm').format(dateTime);
    }
  }
}
