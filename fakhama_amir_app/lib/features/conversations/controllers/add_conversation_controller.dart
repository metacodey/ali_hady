import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import 'conversation_controller.dart';

class AddConversationController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  ConversationController conversationController =
      Get.find<ConversationController>();
  final DataApi dataApi = DataApi(Get.find());

  // حقل موضوع المحادثة
  final TextEditingController subjectController = TextEditingController();

  // التحقق من صحة البيانات
  bool validateConversation() {
    if (subjectController.text.trim().isEmpty) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى إدخال موضوع المحادثة',
        color: Colors.red,
      );
      return false;
    }

    if (subjectController.text.trim().length < 3) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يجب أن يكون موضوع المحادثة أكثر من 3 أحرف',
        color: Colors.red,
      );
      return false;
    }

    return true;
  }

  // بناء بيانات المحادثة للإرسال
  Map<String, dynamic> _buildConversationData() {
    return {
      'subject': subjectController.text.trim(),
    };
  }

  // حفظ المحادثة الجديدة
  Future<void> saveConversation() async {
    if (!validateConversation()) return;

    final conversationData = _buildConversationData();

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.addConversation(conversationData);
      },
      onSuccess: (res) {
        conversationController.fetchData(hideLoading: true);
        Get.back();
        showSnakBar(
          title: 'نجح',
          msg: 'تم إنشاء المحادثة بنجاح',
          color: Colors.green,
        );
      },
      onError: showError,
    );
  }

  // إعادة تعيين البيانات
  void resetForm() {
    subjectController.clear();
  }

  @override
  void onClose() {
    subjectController.dispose();
    super.onClose();
  }
}
