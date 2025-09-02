import 'package:fakhama_amiradmin_app/features/orders/models/order_model.dart';
import 'package:fakhama_amiradmin_app/features/orders/models/status_model.dart';
import 'package:fakhama_amiradmin_app/services/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';

class OrdersController extends GetxController {
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
  RxList<OrderModel> orders = RxList<OrderModel>([]);
  RxList<StatusModel> statusOrder = RxList<StatusModel>([]);

  // متغيرات البحث والفلترة
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  RxString searchQuery = ''.obs;
  Rx<StatusModel?> selectedStatus = Rx<StatusModel?>(null);

  // قائمة الطلبات المفلترة
  RxList<OrderModel> filteredOrders = RxList<OrderModel>([]);

  // دالة تعيين استعلام البحث
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // دالة تعيين الحالة المحددة
  void setStatus(StatusModel? status) {
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
    List<OrderModel> filtered = orders.toList();

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((order) {
        final query = searchQuery.value.toLowerCase();
        return (order.orderNumber.toLowerCase().contains(query)) ||
            (order.customerName.toLowerCase().contains(query)) ||
            (order.customerPhone.toLowerCase().contains(query));
      }).toList();
    }

    // تطبيق فلتر الحالة
    if (selectedStatus.value != null &&
        selectedStatus.value != 'جميع الحالات') {
      filtered = filtered.where((order) {
        return order.status == selectedStatus.value;
      }).toList();
    }

    filteredOrders.value = filtered;
  }

  Future<void> fetchData(
      {bool hideLoading = false, int page = 1, bool isRefresh = false}) async {
    if (statusRequest.value.isLoading) return;

    // إذا كان تحديث، نعيد تعيين البيانات
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      orders.clear();
    }

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getOrdersList(page: page),
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          List<OrderModel> newOrders =
              data.map((e) => OrderModel.fromJson(e)).toList();

          if (page == 1 || isRefresh) {
            orders.value = newOrders;
          } else {
            orders.addAll(newOrders);
          }
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
            await dataApi.getOrdersList(page: currentPage.value + 1),
        onSuccess: (res) {
          var data = res['data'] as List?;
          if (data != null) {
            List<OrderModel> newOrders = data
                .map(
                  (e) => OrderModel.fromJson(e),
                )
                .toList();

            orders.addAll(newOrders);
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

  Future<void> fetachStatus() async {
    await handleRequestfunc(
      apiCall: () async {
        return await dataApi.getStatus();
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          statusOrder.assignAll(data.map(
            (e) => StatusModel.fromJson(e),
          ));
        }
      },
      onError: showError,
    );
  }

  Future<void> deleteOrder(int id) async {
    await handleRequestfunc(
      apiCall: () async {
        return await dataApi.deleteOrder(id);
      },
      onSuccess: (res) {
        fetchData(hideLoading: true);
        showSnakBar(
            title: 'success'.tr,
            msg: 'تم حذف الطلب بنجاح'.tr,
            color: Colors.green);
      },
      onError: showError,
    );
  }

  Future<void> updateOrderStatus(int orderId, StatusModel newStatus,
      {String note = ""}) async {
    await handleRequestfunc(
      apiCall: () async {
        return await dataApi.updateOrderStatus(
            orderId, {"status_id": newStatus.id, 'note': note});
      },
      onSuccess: (res) {
        fetchData(hideLoading: true);
        showSnakBar(
            title: 'success'.tr,
            msg: 'تم تحديث حالة الطلب بنجاح'.tr,
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
    fetachStatus();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    scroller.dispose();
    super.onClose();
  }
}
