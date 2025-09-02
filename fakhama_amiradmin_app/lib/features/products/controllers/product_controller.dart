import 'package:fakhama_amiradmin_app/features/products/models/products_model.dart';
import 'package:fakhama_amiradmin_app/services/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';

class ProductController extends GetxController {
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
  RxList<ProductModel> products = RxList<ProductModel>([]);

  // متغيرات البحث والفلترة
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  RxString searchQuery = ''.obs;
  Rx<String?> selectedStatus = Rx<String?>(null);
  RxList<String> uniqueStatuses =
      <String>['جميع الحالات', 'نشط', 'غير نشط'].obs;

  // قائمة المنتجات المفلترة
  RxList<ProductModel> filteredProducts = RxList<ProductModel>([]);

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
    selectedStatus.value = null;
    _applyFilters();
  }

  // دالة تطبيق الفلاتر
  void _applyFilters() {
    List<ProductModel> filtered = products.toList();

    // تطبيق فلتر البحث
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) {
        final query = searchQuery.value.toLowerCase();
        return (product.name.toLowerCase().contains(query)) ||
            (product.sku.toLowerCase().contains(query)) ||
            (product.description?.toLowerCase().contains(query) ?? false) ||
            (product.categoryName?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // تطبيق فلتر الحالة
    if (selectedStatus.value != null &&
        selectedStatus.value != 'جميع الحالات') {
      filtered = filtered.where((product) {
        switch (selectedStatus.value) {
          case 'نشط':
            return product.isActive == true;
          case 'غير نشط':
            return product.isActive == false;
          default:
            return true;
        }
      }).toList();
    }

    filteredProducts.value = filtered;
  }

  Future<void> fetchData(
      {bool hideLoading = false, int page = 1, bool isRefresh = false}) async {
    if (statusRequest.value.isLoading) return;

    // إذا كان تحديث، نعيد تعيين البيانات
    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      products.clear();
    }

    await handleRequestfunc(
      hideLoading: true,
      status: hideLoading ? null : (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.getProductsList(page: page),
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          List<ProductModel> newProducts =
              data.map((e) => ProductModel.fromJson(e)).toList();

          if (page == 1 || isRefresh) {
            products.value = newProducts;
          } else {
            products.addAll(newProducts);
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
            await dataApi.getProductsList(page: currentPage.value + 1),
        onSuccess: (res) {
          var data = res['data'] as List?;
          if (data != null) {
            List<ProductModel> newProducts = data
                .map(
                  (e) => ProductModel.fromJson(e),
                )
                .toList();

            products.addAll(newProducts);
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

  Future<void> deleteProduct(int id) async {
    await handleRequestfunc(
      apiCall: () async {
        return await dataApi.deleteProduct(id);
      },
      onSuccess: (res) {
        fetchData(hideLoading: true);
        showSnakBar(
            title: 'success'.tr,
            msg: 'تم حذف المنتج بنجاح'.tr,
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
