import 'package:fakhama_amir_app/core/class/preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../../orders/screens/home_orders_screen.dart';
import '../model/navigtor_model.dart';

class HomeController extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  final DataApi dataApi = DataApi(Get.find());
  GlobalKey<ScaffoldState> drawer = GlobalKey();
  var pageIndex = 1.obs;

  // حالة تحديث الموقع
  RxBool isUpdatingLocation = false.obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);

  List<NavigatorModel> items = [
    NavigatorModel(
      title: 'chat',
      icon: LucideIcons.chefHat,
    ),
    NavigatorModel(
      title: 'orders', // الطلبات
      icon: LucideIcons.shoppingBag, // أيقونة مشتريات
    ),
    NavigatorModel(
      title: 'payments', // الدفعات
      icon: LucideIcons.creditCard,
    ),
  ];

  List<Widget> screens = [
    Center(
      child: Text('1'),
    ),
    const HomeOrdersScreen(),
    Center(
      child: Text('3'),
    ),
  ];

  void jumpToPage(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getCurrentLocation() async {
    try {
      isUpdatingLocation.value = true;

      if (!await Geolocator.isLocationServiceEnabled()) {
        isUpdatingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isUpdatingLocation.value = false;
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      currentPosition.value = position;
      isUpdatingLocation.value = false;
      updateLocation();
    } catch (e) {
      isUpdatingLocation.value = false;
    }
  }

  Future<void> updateLocation() async {
    var user = Preferences.getDataUser();
    Map<String, dynamic> locationData = {
      "city": "بغداد", // يمكنك تحديث هذا ليكون ديناميكي
      "street_address": "الموقع الحالي", // يمكنك تحسين هذا
      "country": "العراق",
      "latitude": currentPosition.value!.latitude,
      "longitude": currentPosition.value!.longitude
    };
    await handleRequestfunc(
      apiCall: () async =>
          await dataApi.updateLocationCustomer(user!.id!, locationData),
      onSuccess: (res) {},
      onError: showError,
    );
  }

  List<BottomNavigationBarItem> buildBottomNavItems() {
    return items.asMap().entries.map((entry) {
      NavigatorModel item = entry.value;
      return BottomNavigationBarItem(
        icon: Icon(item.icon),
        activeIcon: Icon(item.icon, color: Colors.blue), // لون عند التحديد
        label: item.title.tr,
      );
    }).toList();
  }

  void showDrawer() {
    drawer.currentState?.openDrawer();
  }
}
