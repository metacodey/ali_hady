// import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/statusrequest.dart';
// import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../models/order_model.dart';

class OrderDetailsController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  final DataApi dataApi = DataApi(Get.find());

  Rx<OrderModel?> orderDetails = Rx<OrderModel?>(null);

  Future<void> fetchOrderDetails(int orderId) async {
    await handleRequestfunc(
      status: (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.showOrder(orderId),
      onSuccess: (res) {
        var data = res['data'];
        if (data != null) {
          orderDetails.value = OrderModel.fromJson(data);
        }
      },
      onError: showError,
    );
  }

  Future<void> addPayment(int orderId, Map<String, dynamic> paymentData) async {
    // await handleRequestfunc(
    //   apiCall: () async => await dataApi.addPayment(orderId, paymentData),
    //   onSuccess: (res) {
    //     fetchOrderDetails(orderId);
    //     showSnakBar(
    //       title: 'success'.tr,
    //       msg: 'تم إضافة الدفعة بنجاح'.tr,
    //       color: Colors.green,
    //     );
    //   },
    //   onError: showError,
    // );
  }

  @override
  void onInit() {
    super.onInit();
    // Get order ID from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments['orderId'] != null) {
      fetchOrderDetails(arguments['orderId']);
    }
  }
}
