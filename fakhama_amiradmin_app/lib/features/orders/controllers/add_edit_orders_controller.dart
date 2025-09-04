import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/orders_controller.dart';
import 'package:fakhama_amiradmin_app/services/helper_function.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../products/models/products_model.dart';

class OrderItem {
  final ProductModel product;
  final RxInt quantity;

  OrderItem({required this.product, int initialQuantity = 1})
      : quantity = initialQuantity.obs;
}

class AddEditOrdersController extends GetxController {
  // حالة الطلب
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadCustomers = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadProducts = StatusRequest.none.obs;
  OrdersController ordersController = Get.find<OrdersController>();
  final DataApi dataApi = DataApi(Get.find());

  // البيانات
  RxList<UserModel> customers = RxList<UserModel>([]);
  RxList<ProductModel> products = RxList<ProductModel>([]);
  RxList<OrderItem> orderItems = RxList<OrderItem>([]);

  // العميل المحدد
  Rx<UserModel?> selectedCustomer = Rx<UserModel?>(null);

  // ملاحظات العميل
  final TextEditingController customerNotesController = TextEditingController();

  // المجموع الكلي
  RxDouble totalAmount = 0.0.obs;

  Future<void> getCustomersOrders() async {
    await handleRequestfunc(
      hideLoading: true,
      status: (status) => statusLoadCustomers.value = status,
      apiCall: () async {
        return await dataApi.getCustomersOrders();
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          customers.assignAll(data.map(
            (e) => UserModel.fromJson(e),
          ));
        }
      },
      onError: showError,
    );
  }

  Future<void> getProductsOrders() async {
    await handleRequestfunc(
      hideLoading: true,
      status: (status) => statusLoadProducts.value = status,
      apiCall: () async {
        return await dataApi.getProductsOrders();
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          products.assignAll(data.map(
            (e) => ProductModel.fromJson(e),
          ));
        }
      },
      onError: showError,
    );
  }

  // تحديد العميل
  void selectCustomer(UserModel? customer) {
    selectedCustomer.value = customer;
  }

  // إضافة منتج للطلب
  void addProductToOrder(ProductModel product) {
    // التحقق من وجود المنتج مسبقاً
    int existingIndex =
        orderItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // زيادة الكمية إذا كان المنتج موجود
      orderItems[existingIndex].quantity.value++;
    } else {
      // إضافة منتج جديد
      orderItems.add(OrderItem(product: product));
    }

    calculateTotal();
  }

  // تحديث كمية المنتج
  void updateProductQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeProductFromOrder(index);
    } else {
      orderItems[index].quantity.value = quantity;
      calculateTotal();
    }
  }

  // حذف منتج من الطلب
  void removeProductFromOrder(int index) {
    orderItems.removeAt(index);
    calculateTotal();
  }

  // حساب المجموع الكلي
  void calculateTotal() {
    double total = 0.0;
    for (var item in orderItems) {
      total += item.product.price * item.quantity.value;
    }
    totalAmount.value = total;
  }

  // التحقق من صحة البيانات
  bool validateOrder() {
    if (selectedCustomer.value == null) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى اختيار العميل',
        color: Colors.red,
      );
      return false;
    }

    if (orderItems.isEmpty) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى إضافة منتج واحد على الأقل',
        color: Colors.red,
      );
      return false;
    }

    return true;
  }

  // بناء بيانات الطلب للإرسال
  Map<String, dynamic> _buildOrderData() {
    List<Map<String, dynamic>> items = orderItems
        .map((item) => {
              'product_id': item.product.id,
              'quantity': item.quantity.value,
            })
        .toList();

    return {
      'customer_id': selectedCustomer.value!.id,
      'items': items,
      'customer_notes': customerNotesController.text.trim(),
    };
  }

  // حفظ الطلب
  Future<void> saveOrder() async {
    if (!validateOrder()) return;
    final orderData = _buildOrderData();
    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        return await dataApi.addOrder(orderData);
      },
      onSuccess: (res) {
        ordersController.fetchData(hideLoading: true);
        Get.back();
        showSnakBar(
          title: 'نجح',
          msg: 'تم إنشاء الطلب بنجاح',
          color: Colors.green,
        );
      },
      onError: showError,
    );
  }

  @override
  void onInit() {
    super.onInit();
    getCustomersOrders();
    getProductsOrders();
  }

  @override
  void onClose() {
    customerNotesController.dispose();
    super.onClose();
  }
}
