import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/preferences.dart';
import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'conversation_controller.dart';
// إضافة استيراد خدمة Socket
import '../../../services/socket_service.dart';

class ChatController extends GetxController {
  final DataApi dataApi = DataApi(Get.find());
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();
  ConversationController conversationController =
      Get.find<ConversationController>();
  // إضافة خدمة Socket
  late SocketService socketService;

  // حالة الطلبات
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusSendMessage = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadMore = StatusRequest.none.obs;
  final FocusNode inputFocus = FocusNode();

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
    // تهيئة خدمة Socket
    socketService = Get.find<SocketService>();
    _setupScrollListener();
    _setupSocketListeners();

    // الحصول على معرف المحادثة من الـ arguments
    final conversationData = Get.arguments;
    if (conversationData != null) {
      if (conversationData is ConversationModel) {
        conversation.value = conversationData;
        _joinConversation();
        loadMessages();
      } else if (conversationData is Map &&
          conversationData['conversation'] != null) {
        conversation.value = conversationData['conversation'];
        _joinConversation();
        loadMessages();
      }
    }
  }

  // إعداد مستمعي Socket
  void _setupSocketListeners() {
    // الاستماع للرسائل الجديدة
    socketService.on('new_message', (data) {
      print('📨 New message received in chat: $data');
      _handleNewMessage(data);
    });

    // الاستماع لتأكيد إرسال الرسالة
    socketService.on('message_sent', (data) {
      print('✅ Message sent confirmation: $data');
      _handleMessageSent(data);
    });

    // الاستماع لتحديث حالة قراءة الرسالة
    socketService.on('message_read_notification', (data) {
      print('👁️ Message read: $data');
      _handleMessageRead(data);
    });
  }

  // الانضمام للمحادثة
  void _joinConversation() {
    if (conversation.value != null) {
      socketService.joinConversation(conversation.value!.id!);
    }
  }

  // مغادرة المحادثة
  void _leaveConversation() {
    if (conversation.value != null) {
      socketService.leaveConversation(conversation.value!.id!);
    }
  }

  // معالجة رسالة جديدة
  void _handleNewMessage(Map<String, dynamic> data) {
    try {
      final conversationId = data['conversation_id'];

      // التحقق من أن الرسالة تخص المحادثة الحالية
      if (conversation.value != null &&
          conversationId == conversation.value!.id) {
        final messageData = data['message'];
        if (messageData != null) {
          final newMessage = MessageModel.fromJson(messageData);

          // إضافة الرسالة إلى القائمة
          messages.add(newMessage);

          // إرسال إشعار القراءة تلقائياً إذا كانت الرسالة من العميل
          if (newMessage.senderType == 'customer') {
            _sendReadNotification(newMessage);
          }

          // التمرير إلى أسفل
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
      }
    } catch (e) {
      print('❌ Error handling new message in chat: $e');
    }
  }

  // إرسال إشعار القراءة
  void _sendReadNotification(MessageModel message) {
    try {
      final user = Preferences.getDataUser();
      if (user != null && conversation.value != null) {
        // إرسال إشعار القراءة عبر Socket
        socketService.markMessageAsRead({
          'id': message.id,
          'conversation_id': conversation.value!.id,
          'reciver_id':
              conversationController.customer.value!.id, // إرسال للمرسل الأصلي
          'reader_id': user.id,
          'reader_type': 'user' // المشرف
        });

        // تحديث الرسالة محلياً
        int index = messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          messages[index] = message.copyWith(isRead: true);
          markMessageAsRead(message);
        }

        print('✅ Read notification sent for message ${message.id}');
      }
    } catch (e) {
      print('❌ Error sending read notification: $e');
    }
  }

  // معالجة تحديث حالة قراءة الرسالة
  void _handleMessageRead(Map<String, dynamic> data) {
    try {
      final messageId = data['message_id'];

      // البحث عن الرسالة وتحديث حالة القراءة
      int index = messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        messages[index] = messages[index].copyWith(isRead: true);
        print('✅ Message ${messageId} marked as read by admin');
      }
    } catch (e) {
      print('❌ Error handling message read update: $e');
    }
  }

  // معالجة تأكيد إرسال الرسالة
  void _handleMessageSent(Map<String, dynamic> data) {
    try {
      final tempId = data['temp_id'];
      final messageData = data['message'];

      if (tempId != null && messageData != null) {
        // البحث عن الرسالة المؤقتة وإزالتها
        messages.removeWhere((msg) => msg.id.toString() == tempId);

        // إضافة الرسالة الحقيقية
        final realMessage = MessageModel.fromJson(messageData);
        messages.add(realMessage);

        // التمرير إلى أسفل
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      print('❌ Error handling message sent confirmation: $e');
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
    inputFocus.requestFocus();
    var user = Preferences.getDataUser();
    final messageText = messageController.text.trim();

    // إضافة الرسالة محلياً فوراً مع نوع 'user'
    var tempMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch, // معرف مؤقت
        conversationId: conversation.value!.id!,
        message: messageText,
        senderType: 'user', // تحديد نوع المرسل كـ user
        senderId: user!.id, // يمكن إضافة معرف المستخدم الحالي هنا
        isRead: false,
        reciverId: conversationController.customer.value!.id!,
        createdAt: DateTime.now(),
        senderName: user.fullName, // أو اسم المستخدم الحالي
        customerId: 00);
    // إضافة الرسالة في آخر القائمة
    messages.add(tempMessage);
    messageController.clear();

    // التمرير إلى أسفل فوراً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // إرسال الرسالة عبر API أولاً
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
          tempMessage = tempMessage.copyWith(
              id: realMessage.id, createdAt: realMessage.createdAt);

          socketService.sendMessage(data: tempMessage.toJson());
          messages.add(tempMessage);

          // التمرير إلى أسفل
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }

        print('✅ Message sent via API successfully');
      },
      onError: (error) {
        // إزالة الرسالة المؤقتة في حالة الخطأ
        messages.removeWhere((msg) => msg.id == tempMessage.id);
        messageController.text = messageText;
        showError(error);
      },
    );
  }

  // تحديد رسالة واحدة كمقروءة
  Future<void> markMessageAsRead(MessageModel message) async {
    if (message.isRead) return;
    log("------------------------------${message.isRead}");
    await dataApi.markMessageAsRead(message.id);
    // تحديث الرسالة محلياً
    int index = messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      messages[index] = message.copyWith(isRead: true);
      _sendReadNotification(message.copyWith(isRead: true));
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
    _leaveConversation();
    Get.back();
  }

  // تحديث حالة المحادثة إلى مغلقة
  Future<void> updateConversationStatus(String state) async {
    if (conversation.value == null) return;

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.updateConversationStatus(
          conversation.value!.id!,
          {'status': state},
        );
      },
      onSuccess: (res) {
        // تحديث حالة المحادثة محلياً
        if (conversation.value != null) {
          conversation.value = conversation.value!.copyWith(
            status: 'closed',
          );
        }
        socketService.changeConversationState({
          'conversation_id': conversation.value!.id!,
          'status': state,
          'updated_by': "ali",
        });
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
    // مغادرة المحادثة وإزالة مستمعي Socket
    _leaveConversation();
    socketService.off('new_message');
    socketService.off('message_sent');
    socketService.off('message_read');

    scrollController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
