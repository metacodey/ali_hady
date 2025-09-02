import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:fakhama_amiradmin_app/services/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';

class ClientsController extends GetxController {
  // حالة الطلب
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadMore = StatusRequest.none.obs;
  final ScrollController scroller = ScrollController();

  final DataApi dataApi = DataApi(Get.find());

  // متغيرات التصفح (Pagination)
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalItems = 10.obs;

  RxBool hasMoreData = true.obs;
  RxBool isLoadingMore = false.obs;
  RxList<UserModel> clients = RxList<UserModel>([]);

  // متغيرات البحث والفلترة
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  RxString searchQuery = ''.obs;
  Rx<String?> selectedStatus = Rx<String?>(null);
  RxList<String> uniqueStatuses =
      <String>['جميع الحالات', 'نشط', 'غير نشط', 'محظور'].obs;

  // قائمة العملاء المفلترة
  RxList<UserModel> filteredClients = RxList<UserModel>([]);

  // دالة تعيين استعلام البحث
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // دالة تعيين الحالة المحددة
  void setStatus(String? status) {
    selectedStatus.value = status ?? '';
    _applyFilters();
  }

  // دالة إعادة تعيين الفلاتر
  void resetFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = '';
    _applyFilters();
  }

  // دالة تطبيق الفلاتر
  void _applyFilters() {
    List<UserModel> filtered = clients.toList();

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((client) {
        final query = searchQuery.value.toLowerCase();
        return (client.fullName.toLowerCase().contains(query)) ||
            (client.email.toLowerCase().contains(query)) ||
            (client.phone.toLowerCase().contains(query));
      }).toList();
    }

    // تطبيق فلتر الحالة
    if (selectedStatus.value != null &&
        selectedStatus.value != 'جميع الحالات') {
      filtered = filtered.where((client) {
        switch (selectedStatus.value) {
          case 'نشط':
            return client.isActive == true;
          case 'غير نشط':
            return client.isActive == false;

          default:
            return true;
        }
      }).toList();
    }

    filteredClients.value = filtered;
  }

  Future<void> fetchData(
      {bool hideLoading = false, int page = 1, bool isRefresh = false}) async {
    if (statusRequest.value.isLoading) return;

    // إذا كان تحديث، نعيد تعيين البيانات
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      clients.clear();
    }

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getCustomersList(page: page),
      onSuccess: (res) {
        var data = res['data'] as List?;

        if (data != null) {
          List<UserModel> newClients =
              data.map((e) => UserModel.fromJson(e)).toList();

          if (page == 1 || isRefresh) {
            clients.value = newClients;
          } else {
            clients.addAll(newClients);
          }
        }

        // تحديث معلومات التصفح
        currentPage.value = res['pagination']['currentPage'] ?? 1;
        totalItems.value = res['pagination']['totalItems'] ?? 10;
        totalPages.value = res['pagination']['totalPages'] ?? 0;

        // التحقق من وجود المزيد من البيانات - إصلاح الحساب
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
        apiCall: () async =>
            await dataApi.getCustomersList(page: currentPage.value + 1),
        onSuccess: (res) {
          var data = res['data'] as List?;
          if (data != null) {
            List<UserModel> newClients = data
                .map(
                  (e) => UserModel.fromJson(e),
                )
                .toList();

            clients.addAll(newClients);
          }
          // تحديث معلومات التصفح
          currentPage.value = res['pagination']['currentPage'] ?? 1;
          totalItems.value = res['pagination']['totalItems'] ?? 10;
          totalPages.value = res['pagination']['totalPages'] ?? 0;

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

  Future<void> deleteClient(int id) async {
    await handleRequestfunc(
      apiCall: () async {
        return await dataApi.deleteCustomer(id);
      },
      onSuccess: (res) {
        fetchData(hideLoading: true);
        showSnakBar(
            title: 'success'.tr,
            msg: 'تم حذف عميل بنجاح'.tr,
            color: Colors.green);
      },
      onError: showError,
    );
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
    scroller.addListener(_scrollListener);

    fetchData();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    scroller.dispose();
    super.onClose();
  }
}
