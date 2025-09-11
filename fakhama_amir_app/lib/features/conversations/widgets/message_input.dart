import 'package:fakhama_amir_app/core/class/statusrequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/utils/widgets/custom_text_field.dart';
import '../controllers/chat_controller.dart';

class MessageInput extends GetView<ChatController> {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E5EA),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomTextField(
                controller: controller.messageController,
                hintText: 'اكتب رسالة...',
                focusNode: controller.inputFocus,
                unFucos: false,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                radius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                    color: AppColors.greenBlueVeryLight, width: 2),
                keyboardType: TextInputType.text,
              ),
            )),
            SizedBox(width: 8.w),
            Obx(() => GestureDetector(
                  onTap: controller.statusSendMessage.value.isLoading
                      ? null
                      : controller.sendMessage,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: controller.statusSendMessage.value.isLoading
                          ? const Color(0xFF8E8E93)
                          : const Color(0xFF007AFF),
                      shape: BoxShape.circle,
                    ),
                    child: controller.statusSendMessage.value.isLoading
                        ? SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
