import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../widgets/appbar_widget.dart';
import '../controllers/add_conversation_controller.dart';
import '../widgets/conversation_details_card.dart';
import '../widgets/save_conversation_button.dart';

class AddConversationScreen extends GetView<AddConversationController> {
  const AddConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        title: 'إنشاء محادثة جديدة',
        appBarWidth: 40.w,
        showWidget: false,
        children: const [],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              // Conversation Details Card
              const ConversationDetailsCard(),

              SizedBox(height: 24.h),

              // Save Button
              const SaveConversationButton(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
