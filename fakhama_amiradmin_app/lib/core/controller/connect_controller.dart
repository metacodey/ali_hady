import 'dart:async';
import 'dart:developer';

import 'package:fakhama_amiradmin_app/features/clients/controllers/clients_controller.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../features/map/controllers/map_app_controller.dart';
import '../../features/orders/controllers/orders_controller.dart';
import '../../features/products/controllers/product_controller.dart';
import '../class/preferences.dart';

class ConnectController extends GetxController {
  final connectionChecker = InternetConnectionChecker.instance;
  StreamSubscription<InternetConnectionStatus>? subscription;
  bool checkIsConnect = true;

  Future<void> checkInternet() async {
    subscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) async {
        if (status == InternetConnectionStatus.connected) {
          if (Preferences.getBoolean(Preferences.isLogin) && !checkIsConnect) {
            checkIsConnect = true;
            update();
            await Future.delayed(const Duration(milliseconds: 200));
            await _fetchDataFromControllers();
          }
          checkIsConnect = true;
          update();
          log('Connected to the internet');
        } else {
          checkIsConnect = false;
          update();
          log('Disconnected from the internet');
        }
      },
    );
  }

  Future<void> _fetchDataFromControllers() async {
    if (Get.isRegistered<ClientsController>()) {
      await Get.find<ClientsController>().fetchData(hideLoading: true);
    }
    if (Get.isRegistered<ProductController>()) {
      await Get.find<ProductController>().fetchData(hideLoading: true);
    }
    if (Get.isRegistered<MapAppController>()) {
      await Get.find<MapAppController>().fetchData(hideLoading: true);
    }
    if (Get.isRegistered<OrdersController>()) {
      await Get.find<OrdersController>().fetchData(hideLoading: true);
    }
    // if (Get.isRegistered<SettingController>()) {
    //   await Get.find<SettingController>().getSetting();
    // }
    // if (Get.isRegistered<FavoritesController>()) {
    //   await Get.find<FavoritesController>().getFavoriteProducts();
    // }
  }

  @override
  void onInit() {
    checkInternet();
    super.onInit();
  }

  @override
  void onClose() {
    subscription?.cancel();

    super.onClose();
  }
}
