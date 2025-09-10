import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../models/payment_model.dart';

class PaymentController extends GetxController {
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
  RxList<PaymentModel> payments = RxList<PaymentModel>([]);

  // متغيرات البحث والفلترة
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  RxString searchQuery = ''.obs;
  Rx<String?> selectedStatus = Rx<String?>(null);
  Rx<String?> selectedPaymentMethod = Rx<String?>(null);

  RxList<String> uniqueStatuses =
      <String>['جميع الحالات', 'مدفوع', 'في الانتظار', 'ملغي'].obs;

  RxList<String> uniquePaymentMethods = <String>[
    'جميع طرق الدفع',
    'نقداً',
    'بطاقة ائتمان',
    'تحويل بنكي',
    'محفظة إلكترونية'
  ].obs;

  // قائمة الدفعات المفلترة
  RxList<PaymentModel> filteredPayments = RxList<PaymentModel>([]);

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

  // دالة تعيين طريقة الدفع المحددة
  void setPaymentMethod(String? method) {
    selectedPaymentMethod.value = method;
    _applyFilters();
  }

  // دالة إعادة تعيين الفلاتر
  void resetFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedStatus.value = null;
    selectedPaymentMethod.value = null;
    _applyFilters();
  }

  // دالة تطبيق الفلاتر
  void _applyFilters() {
    List<PaymentModel> filtered = payments.toList();

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((payment) {
        final query = searchQuery.value.toLowerCase();
        return (payment.orderNumber.toLowerCase().contains(query)) ||
            (payment.customerName.toLowerCase().contains(query)) ||
            (payment.paymentMethod.toLowerCase().contains(query)) ||
            (payment.amount.toLowerCase().contains(query));
      }).toList();
    }

    // تطبيق فلتر الحالة
    if (selectedStatus.value != null &&
        selectedStatus.value != 'جميع الحالات') {
      filtered = filtered.where((payment) {
        switch (selectedStatus.value) {
          case 'مدفوع':
            return payment.isPaid;
          case 'في الانتظار':
            return payment.isPending;
          case 'ملغي':
            return payment.isCancelled;
          default:
            return true;
        }
      }).toList();
    }

    // تطبيق فلتر طريقة الدفع
    if (selectedPaymentMethod.value != null &&
        selectedPaymentMethod.value != 'جميع طرق الدفع') {
      filtered = filtered.where((payment) {
        return payment.paymentMethod
            .toLowerCase()
            .contains(selectedPaymentMethod.value!.toLowerCase());
      }).toList();
    }

    filteredPayments.value = filtered;
  }

  Future<void> fetchData(
      {bool hideLoading = false, int page = 1, bool isRefresh = false}) async {
    if (statusRequest.value.isLoading) return;

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getMyPayments(),
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          List<PaymentModel> newPayments =
              data.map((e) => PaymentModel.fromJson(e)).toList();

          if (page == 1 || isRefresh) {
            payments.value = newPayments;
          } else {
            payments.addAll(newPayments);
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
            await dataApi.getPaymentsList(page: currentPage.value + 1),
        onSuccess: (res) {
          var data = res['data'] as List?;
          if (data != null) {
            List<PaymentModel> newPayments = data
                .map(
                  (e) => PaymentModel.fromJson(e),
                )
                .toList();

            payments.addAll(newPayments);
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
