import 'package:fakhama_amir_app/core/class/preferences.dart';
import 'package:fakhama_amir_app/core/constants/utils/widgets/snak_bar.dart';
import 'package:fakhama_amir_app/features/conversations/controllers/conversation_controller.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatController extends GetxController {
  final DataApi dataApi = DataApi(Get.find());
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  ConversationController conversationController =
      Get.find<ConversationController>();
  // حالة الطلبات
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusSendMessage = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadMore = StatusRequest.none.obs;

  // بيانات المحادثة
  Rx<ConversationModel?> conversation = Rx<ConversationModel?>(null);
  RxList<MessageModel> messages = RxList<MessageModel>([]);

  // التصفح
  RxInt currentPage = 1.obs;
  RxBool hasMoreMessages = true.obs;
  RxBool isLoadingMore = false.obs;

  // عدد الرسائل غير المقروءة
  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();

    // الحصول على معرف المحادثة من الـ arguments
    final conversationData = Get.arguments;
    if (conversationData != null) {
      if (conversationData is ConversationModel) {
        conversation.value = conversationData;
        loadMessages();
      } else if (conversationData is Map &&
          conversationData['conversation'] != null) {
        conversation.value = conversationData['conversation'];
        loadMessages();
      }
    }
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (hasMoreMessages.value && !isLoadingMore.value) {
          loadMoreMessages();
        }
      }
    });
  }

  // تحميل الرسائل
  Future<void> loadMessages({bool hideLoading = false}) async {
    if (conversation.value == null) return;

    await handleRequestfunc(
      hideLoading: hideLoading,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.getConversationMessages(
          conversation.value!.id!,
          page: 1,
          limit: 20,
        );
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          messages.assignAll(
            data.map((e) => MessageModel.fromJson(e)).toList().reversed,
          );

          // تحديث معلومات التصفح
          var pagination = res['pagination'];
          if (pagination != null) {
            currentPage.value = pagination['currentPage'] ?? 1;
            hasMoreMessages.value = pagination['hasNextPage'] ?? false;
          }

          // تحديث معلومات المحادثة
          var conversationData = res['conversation'];
          if (conversationData != null && conversation.value != null) {
            conversation.value = conversation.value!.copyWith(
              customerName: conversationData['customer_name'],
            );
          }

          // التمرير إلى أسفل
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          // تحديد الرسائل كمقروءة
          // markAllMessagesAsRead();
        }
      },
      onError: showError,
    );
  }

  // تحميل المزيد من الرسائل
  Future<void> loadMoreMessages() async {
    if (conversation.value == null || isLoadingMore.value) return;

    isLoadingMore.value = true;

    await handleRequestfunc(
      hideLoading: true,
      status: (status) => statusLoadMore.value = status,
      apiCall: () async {
        return await dataApi.getConversationMessages(
          conversation.value!.id!,
          page: currentPage.value + 1,
          limit: 20,
        );
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null && data.isNotEmpty) {
          var newMessages = data.map((e) => MessageModel.fromJson(e)).toList();
          messages.insertAll(0, newMessages.reversed);

          // تحديث معلومات التصفح
          var pagination = res['pagination'];
          if (pagination != null) {
            currentPage.value = pagination['currentPage'] ?? currentPage.value;
            hasMoreMessages.value = pagination['hasNextPage'] ?? false;
          }
        } else {
          hasMoreMessages.value = false;
        }
      },
      onError: (error) {
        // في حالة الخطأ، لا نظهر رسالة خطأ للمستخدم
        hasMoreMessages.value = false;
      },
    );

    isLoadingMore.value = false;
  }

  // إرسال رسالة
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || conversation.value == null) {
      return;
    }
    var user = Preferences.getDataUser();
    final messageText = messageController.text.trim();

    // إضافة الرسالة محلياً فوراً مع نوع 'user'
    final tempMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch, // معرف مؤقت
      conversationId: conversation.value!.id!,
      message: messageText,
      senderType: 'customer', // تحديد نوع المرسل كـ user
      senderId: user!.id, // يمكن إضافة معرف المستخدم الحالي هنا
      isRead: false,
      createdAt: DateTime.now(),
      senderName: 'أنت', // أو اسم المستخدم الحالي
      customerId: user.id,
    );

    // إضافة الرسالة في آخر القائمة
    messages.add(tempMessage);
    messageController.clear();

    // التمرير إلى أسفل فوراً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    await handleRequestfunc(
      hideLoading: true,
      status: (status) => statusSendMessage.value = status,
      apiCall: () async {
        return await dataApi.addMessage({
          'conversation_id': conversation.value!.id,
          'message': messageText,
        });
      },
      onSuccess: (res) {
        // إزالة الرسالة المؤقتة
        messages.removeWhere((msg) => msg.id == tempMessage.id);

        // إضافة الرسالة الحقيقية من الاستجابة
        var messageData = res['data'];
        if (messageData != null) {
          final realMessage = MessageModel.fromJson(messageData);
          messages.add(realMessage);
        } else {
          // في حالة عدم وجود بيانات، إعادة تحميل الرسائل
          loadMessages(hideLoading: true);
        }

        // التمرير إلى أسفل مرة أخرى
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      },
      onError: (error) {
        // إزالة الرسالة المؤقتة في حالة الخطأ
        messages.removeWhere((msg) => msg.id == tempMessage.id);
        messageController.text = messageText;
        showError(error);
      },
    );
  }

  // // تحديد جميع الرسائل كمقروءة
  // Future<void> markAllMessagesAsRead() async {
  //   if (conversation.value == null) return;

  //   await dataApi.markAllMessagesAsRead({
  //     'conversation_id': conversation.value!.id,
  //   });

  //   // تحديث الرسائل محلياً
  //   for (int i = 0; i < messages.length; i++) {
  //     if (!messages[i].isRead) {
  //       messages[i] = messages[i].copyWith(isRead: true);
  //     }
  //   }
  // }

  // تحديد رسالة واحدة كمقروءة
  Future<void> markMessageAsRead(MessageModel message) async {
    if (message.isRead) return;

    await dataApi.markMessageAsRead(message.id);

    // تحديث الرسالة محلياً
    int index = messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      messages[index] = message.copyWith(isRead: true);
    }
  }

  // الحصول على عدد الرسائل غير المقروءة
  Future<void> getUnreadCount() async {
    await handleRequestfunc(
      hideLoading: true,
      status: (status) {},
      apiCall: () async {
        return await dataApi.getUnreadMessagesCount();
      },
      onSuccess: (res) {
        var data = res['data'];
        if (data != null) {
          unreadCount.value = data['unread_count'] ?? 0;
        }
      },
      onError: (error) {
        // لا نظهر خطأ للمستخدم
      },
    );
  }

  // التمرير إلى أسفل
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // إغلاق المحادثة
  void closeConversation() {
    Get.back();
  }

  // تحديث حالة المحادثة إلى مغلقة
  Future<void> updateConversationStatusToClosed() async {
    if (conversation.value == null) return;

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.updateConversationStatus(
          conversation.value!.id!,
          {'status': 'closed'},
        );
      },
      onSuccess: (res) {
        // تحديث حالة المحادثة محلياً
        if (conversation.value != null) {
          conversation.value = conversation.value!.copyWith(
            status: 'closed',
          );
        }
        conversationController.fetchData(hideLoading: true);
        // العودة إلى الشاشة السابقة
        Get.back();
        // إظهار رسالة نجاح
        showSnakBar(
          title: 'تم بنجاح',
          msg: 'تم إغلاق المحادثة بنجاح',
          color: Colors.green,
        );
      },
      onError: (error) {
        showError(error);
      },
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
