import 'package:fakhama_amiradmin_app/core/constants/utils/widgets/snak_bar.dart';
import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:fakhama_amiradmin_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../models/conversation_model.dart';

class ConversationController extends GetxController {
  // حالة الطلب
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadMore = StatusRequest.none.obs;
  final ScrollController scroller = ScrollController();
  late SocketService socketService;
  final DataApi dataApi = DataApi(Get.find());

  // متغيرات التصفح (Pagination)
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalItems = 10.obs;

  RxBool hasMoreData = true.obs;
  RxBool isLoadingMore = false.obs;
  RxList<ConversationModel> conversations = RxList<ConversationModel>([]);
  Rx<UserModel?> customer = Rx<UserModel?>(null);
  // متغيرات البحث والفلترة
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  RxString searchQuery = ''.obs;
  Rx<String?> selectedStatus = Rx<String?>(null);

  RxList<String> uniqueStatuses =
      <String>['جميع الحالات', 'مفتوحة', 'مغلقة', 'في الانتظار'].obs;

  // قائمة المحادثات المفلترة
  RxList<ConversationModel> filteredConversations =
      RxList<ConversationModel>([]);

  // دالة تعيين استعلام البحث
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // دالة تعيين الحالة المحددة
  void setStatus(String? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  // دالة إعادة تعيين الفلاتر
  void resetFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = null;
    _applyFilters();
  }

  // دالة تطبيق الفلاتر
  void _applyFilters() {
    List<ConversationModel> filtered = conversations.toList();

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((conversation) {
        final query = searchQuery.value.toLowerCase();
        return (conversation.subject.toLowerCase().contains(query)) ||
            (conversation.customerName.toLowerCase().contains(query)) ||
            (conversation.lastMessage.toLowerCase().contains(query));
      }).toList();
    }

    // تطبيق فلتر الحالة
    if (selectedStatus.value != null &&
        selectedStatus.value != 'جميع الحالات') {
      filtered = filtered.where((conversation) {
        switch (selectedStatus.value) {
          case 'مفتوحة':
            return conversation.isOpen;
          case 'مغلقة':
            return conversation.isClosed;
          case 'في الانتظار':
            return conversation.isPending;
          default:
            return true;
        }
      }).toList();
    }

    // ترتيب المحادثات: المفتوحة أولاً ثم في الانتظار ثم المغلقة
    filtered.sort((a, b) {
      // إعطاء أولوية للمحادثات المفتوحة
      if (a.isOpen && !b.isOpen) return -1;
      if (!a.isOpen && b.isOpen) return 1;

      // إذا كانت كلاهما مفتوحة أو غير مفتوحة، ترتيب حسب الحالة
      if (!a.isOpen && !b.isOpen) {
        // المحادثات في الانتظار تأتي قبل المغلقة
        if (a.isPending && !b.isPending) return -1;
        if (!a.isPending && b.isPending) return 1;
      }

      // ترتيب حسب آخر تحديث (الأحدث أولاً)
      DateTime aTime = a.updatedAt ?? a.createdAt ?? DateTime.now();
      DateTime bTime = b.updatedAt ?? b.createdAt ?? DateTime.now();
      return bTime.compareTo(aTime);
    });

    filteredConversations.value = filtered;
  }

  Future<void> fetchData(
      {bool hideLoading = false, int page = 1, bool isRefresh = false}) async {
    if (statusRequest.value.isLoading) return;

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getCustomerConversation(
          idCustomer: customer.value!.id!, page: page),
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          List<ConversationModel> newConversations =
              data.map((e) => ConversationModel.fromJson(e)).toList();

          if (page == 1 || isRefresh) {
            conversations.value = newConversations;
          } else {
            conversations.addAll(newConversations);
          }
        }
        // تحديث معلومات التصفح
        currentPage.value = res['pagination']?['currentPage'] ?? 1;
        totalItems.value = res['pagination']?['totalItems'] ?? 10;
        totalPages.value = res['pagination']?['totalPages'] ?? 0;

        // التحقق من وجود المزيد من البيانات
        hasMoreData.value = currentPage.value < totalPages.value;

        // تطبيق الفلاتر على البيانات الجديدة
        _applyFilters();
      },
      onError: showError,
    );
  }

  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      await handleRequestfunc(
        hideLoading: true,
        status: (status) => statusLoadMore.value = status,
        apiCall: () async => await dataApi.getCustomerConversation(
            idCustomer: customer.value!.id!, page: currentPage.value + 1),
        onSuccess: (res) {
          var data = res['data'] as List?;
          if (data != null) {
            List<ConversationModel> newConversations = data
                .map(
                  (e) => ConversationModel.fromJson(e),
                )
                .toList();

            conversations.addAll(newConversations);
          }
          // تحديث معلومات التصفح
          currentPage.value = res['pagination']?['currentPage'] ?? 1;
          totalItems.value = res['pagination']?['totalItems'] ?? 10;
          totalPages.value = res['pagination']?['totalPages'] ?? 0;

          // التحقق من وجود المزيد من البيانات
          hasMoreData.value = currentPage.value < totalPages.value;

          // تطبيق الفلاتر على البيانات الجديدة
          _applyFilters();
        },
        onError: (error) {
          showError(error);
        },
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  // مستمع التمرير للتحميل التلقائي
  void _scrollListener() {
    if (scroller.position.pixels >= scroller.position.maxScrollExtent * 0.8) {
      loadMoreData();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is UserModel) {
      socketService = Get.find<SocketService>();
      customer.value = Get.arguments;
      scroller.addListener(_scrollListener);
      fetchData();
      _setupSocketListeners();
    }
  }

  // إعداد مستمعي Socket
  void _setupSocketListeners() {
    socketService.on('new_conversation', (data) {
      print('📨 New conversation received: $data');
      _handleNewConversation(data);
    });

    socketService.on('conversation_status_changed', (data) {
      print('📋 Conversation status changed: $data');
      _handleConversationStatusChange(data);
    });
  }

  // معالجة المحادثة الجديدة
  void _handleNewConversation(dynamic data) {
    try {
      final conversationData = data['conversation'] ?? data;
      final newConversation = ConversationModel.fromJson(conversationData);

      // إضافة المحادثة الجديدة في بداية القائمة
      conversations.insert(0, newConversation);
      // تطبيق الفلاتر
      _applyFilters();
      // إظهار إشعار للمستخدم
      showSnakBar(
        title: 'محادثة جديدة',
        msg: 'تم إنشاء محادثة جديدة: ${newConversation.subject}',
        color: Colors.green.withOpacity(0.8),
      );
    } catch (e) {
      print('Error handling new conversation: $e');
    }
  }

  // معالجة تغيير حالة المحادثة
  void _handleConversationStatusChange(dynamic data) {
    try {
      final conversationId = data['conversation_id'];
      final newStatus = data['status'];

      // البحث عن المحادثة وتحديث حالتها
      final index =
          conversations.indexWhere((conv) => conv.id == conversationId);
      if (index != -1) {
        // تحديث الحالة حسب النوع
        switch (newStatus) {
          case 'open':
            conversations[index] =
                conversations[index].copyWith(status: 'open');
            break;
          case 'closed':
            conversations[index] =
                conversations[index].copyWith(status: 'closed');
            break;
          case 'pending':
            conversations[index] =
                conversations[index].copyWith(status: 'pending');
            break;
        }
        _applyFilters();
      }
    } catch (e) {
      print('Error handling conversation status change: $e');
    }
  }

  // دالة التحديث
  Future<void> refreshData() async {
    await fetchData(isRefresh: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    scroller.dispose();
    super.onClose();
  }
}
