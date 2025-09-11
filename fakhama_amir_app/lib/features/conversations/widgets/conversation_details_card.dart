import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/constants/utils/widgets/custom_text_field.dart';
import '../controllers/add_conversation_controller.dart';

class ConversationDetailsCard extends GetView<AddConversationController> {
  const ConversationDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Title
            Row(
              children: [
                Icon(
                  Icons.chat_outlined,
                  color: Colors.blue[700],
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'تفاصيل المحادثة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Subject Field
            CustomTextField(
              controller: controller.subjectController,
              label: 'موضوع المحادثة',
              hintText: 'أدخل موضوع المحادثة أو الاستفسار...',
              prefixIcon: Icon(Icons.subject_outlined, color: Colors.blue[600]),
              maxline: 3,
              paddingLable: EdgeInsets.symmetric(vertical: 5.h),
              radius: BorderRadius.circular(10.r),
              fillColor: Get.theme.canvasColor,
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),

            SizedBox(height: 12.h),

            // Helper Text
            Text(
              'اكتب موضوع واضح ومحدد لمساعدة فريق الدعم في فهم استفسارك',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
