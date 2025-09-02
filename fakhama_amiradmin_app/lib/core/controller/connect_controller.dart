import 'dart:async';
import 'dart:developer';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mc_utils/mc_utils.dart';

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
    // if (Get.isRegistered<ProductsController>()) {
    //   await Get.find<ProductsController>().loadAll(showLoading: false);
    // }
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
