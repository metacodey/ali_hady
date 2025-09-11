import 'package:fakhama_amiradmin_app/features/orders/models/order_model.dart';
import 'package:fakhama_amiradmin_app/features/payments/controllers/payment_controller.dart';
import 'package:fakhama_amiradmin_app/features/payments/models/payment_model.dart';
import 'package:mc_utils/mc_utils.dart';
import 'package:flutter/material.dart';

import '../../../core/class/statusrequest.dart';
import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';

class AddEditPaymentControler extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<StatusRequest> statusLoadOrders = StatusRequest.none.obs;
  PaymentController paymentController = Get.find<PaymentController>();
  final DataApi dataApi = DataApi(Get.find());

  // البيانات
  RxList<OrderModel> ordersIncomplete = RxList<OrderModel>([]);

  // الطلب المحدد
  Rx<OrderModel?> selectedOrder = Rx<OrderModel?>(null);

  // بيانات الدفعة
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // طريقة الدفع المحددة
  RxString selectedPaymentMethod = 'نقداً'.obs;

  // قائمة طرق الدفع
  final List<String> paymentMethods = [
    'نقداً',
    'بطاقة ائتمان',
    'تحويل بنكي',
    'محفظة إلكترونية'
  ];

  // المبلغ المتبقي للطلب المحدد
  RxDouble remainingAmount = 0.0.obs;

  // دفعة للتعديل (في حالة التعديل)
  PaymentModel? paymentToEdit;
  bool get isEditMode => paymentToEdit != null;

  Future<void> getOrdersIncomplete() async {
    await handleRequestfunc(
      hideLoading: true,
      status: (status) => statusLoadOrders.value = status,
      apiCall: () async {
        return await dataApi.getOrdersIncomplete();
      },
      onSuccess: (res) {
        var data = res['data'] as List?;
        if (data != null) {
          ordersIncomplete.assignAll(data.map(
            (e) => OrderModel.fromJson(e),
          ));
          if (Get.arguments != null) {
            OrderModel? order = Get.arguments['order'];
            selectedOrder.value = ordersIncomplete.firstWhereOrNull(
              (element) => element.id == order?.id,
            );
          }
        }
      },
      onError: showError,
    );
  }

  // تحديد الطلب
  void selectOrder(OrderModel? order) {
    selectedOrder.value = order;
    if (order != null) {
      remainingAmount.value = order.remainingAmount;
      // في حالة التعديل، لا نغير المبلغ
      if (!isEditMode) {
        amountController.text = order.remainingAmount.toStringAsFixed(2);
      }
    } else {
      remainingAmount.value = 0.0;
      if (!isEditMode) {
        amountController.clear();
      }
    }
  }

  // تحديد طريقة الدفع
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // التحقق من صحة البيانات
  bool validatePayment() {
    if (selectedOrder.value == null) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى اختيار الطلب',
        color: Colors.red,
      );
      return false;
    }

    if (amountController.text.trim().isEmpty) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى إدخال مبلغ الدفعة',
        color: Colors.red,
      );
      return false;
    }

    double amount = double.tryParse(amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      showSnakBar(
        title: 'خطأ',
        msg: 'يرجى إدخال مبلغ صحيح',
        color: Colors.red,
      );
      return false;
    }

    // التحقق من عدم تجاوز المبلغ المتبقي
    double maxAllowedAmount = remainingAmount.value;

    // في حالة التعديل، نضيف المبلغ السابق للمبلغ المسموح
    if (isEditMode && paymentToEdit != null) {
      maxAllowedAmount += double.tryParse(paymentToEdit!.amount) ?? 0;
    }

    if (amount > maxAllowedAmount) {
      showSnakBar(
        title: 'خطأ',
        msg:
            'المبلغ المدخل أكبر من المبلغ المتبقي (${maxAllowedAmount.toStringAsFixed(2)})',
        color: Colors.red,
      );
      return false;
    }

    return true;
  }

  // بناء بيانات الدفعة للإرسال
  Map<String, dynamic> _buildPaymentData() {
    return {
      'order_id': selectedOrder.value!.id,
      'amount': double.parse(amountController.text.trim()),
      'payment_method': selectedPaymentMethod.value,
      'notes': notesController.text.trim(),
    };
  }

  // حفظ الدفعة (إضافة أو تعديل)
  Future<void> savePayment() async {
    if (!validatePayment()) return;

    final paymentData = _buildPaymentData();

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        if (isEditMode) {
          // return await dataApi.updatePayment(paymentToEdit!.id, paymentData);
        } else {
          return await dataApi.addPayment(paymentData);
        }
      },
      onSuccess: (res) {
        paymentController.fetchData(hideLoading: true);
        Get.back();
        showSnakBar(
          title: 'نجح',
          msg: isEditMode ? 'تم تعديل الدفعة بنجاح' : 'تم إضافة الدفعة بنجاح',
          color: Colors.green,
        );
      },
      onError: showError,
    );
  }

  // تهيئة البيانات للتعديل
  void initForEdit(PaymentModel payment) {
    paymentToEdit = payment;
    amountController.text = payment.amount;
    notesController.text = payment.note ?? '';
    selectedPaymentMethod.value = payment.paymentMethod;

    // البحث عن الطلب المرتبط
    final order = ordersIncomplete.firstWhereOrNull(
      (o) => o.orderNumber == payment.orderNumber,
    );
    if (order != null) {
      selectOrder(order);
    }
  }

  // إعادة تعيين البيانات
  void resetForm() {
    selectedOrder.value = null;
    amountController.clear();
    notesController.clear();
    selectedPaymentMethod.value = 'نقداً';
    remainingAmount.value = 0.0;
    paymentToEdit = null;
  }

  @override
  void onInit() {
    super.onInit();
    getOrdersIncomplete();
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
