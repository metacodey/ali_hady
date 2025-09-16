import 'package:fakhama_amiradmin_app/core/class/preferences.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../../../services/socket_service.dart';
import 'conversation_controller.dart';

class AddConversationController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  ConversationController conversationController =
      Get.find<ConversationController>();
  final DataApi dataApi = DataApi(Get.find());

  late SocketService socketService;

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
      'customerId': conversationController.customer.value!.id
    };
  }

  @override
  void onInit() {
    super.onInit();
    socketService = Get.find<SocketService>();
  }

  // حفظ المحادثة الجديدة
  Future<void> saveConversation() async {
    if (!validateConversation()) return;

    final conversationData = _buildConversationData();

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.addConversationByAdmin(conversationData);
      },
      onSuccess: (res) {
        // إرسال إشعار Socket للمدير

        _notifyNewConversation(res['data']);

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

  // إرسال إشعار المحادثة الجديدة عبر Socket
  void _notifyNewConversation(dynamic conversationData) {
    try {
      var user = Preferences.getDataUser();
      socketService.createConversation(data: {
        'conversation': {
          ...conversationData,
          ...{'status': 'open', 'user': user?.fullName ?? ""},
        },
        'customer_id': conversationController.customer.value!.id,
        'created_by': 'user', // نوع المستخدم الذي أنشأ المحادثة
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('📤 New conversation notification sent to admin');
    } catch (e) {
      print('Error sending new conversation notification: $e');
    }
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
