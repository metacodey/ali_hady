import 'package:fakhama_amiradmin_app/features/clients/screens/home_clients_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mc_utils/mc_utils.dart';
import '../model/navigtor_model.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> drawer = GlobalKey();
  var pageIndex = 2.obs;

  List<NavigatorModel> items = [
    NavigatorModel(
      title: 'clients', // العملاء
      icon: Icons.people_outline,
    ),
    NavigatorModel(
      title: 'chat', // الدردشة
      icon: LucideIcons.messageCircle,
    ),
    NavigatorModel(
      title: 'map', // الخريطة
      icon: LucideIcons.mapPin,
    ),
    NavigatorModel(
      title: 'products', // المنتجات
      icon: LucideIcons.package,
    ),
    NavigatorModel(
      title: 'payments', // الدفعات
      icon: LucideIcons.creditCard,
    ),
  ];

  List<Widget> screens = [
    const HomeClientsScreen(),
    Center(
      child: Text("1"),
    ),
    Center(
      child: Text("2"),
    ),
    Center(
      child: Text("3"),
    ),
    Center(
      child: Text("4"),
    ),
  ];

  void jumpToPage(int index) {
    pageIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
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
