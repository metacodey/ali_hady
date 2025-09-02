import 'package:fakhama_amiradmin_app/features/clients/screens/home_clients_screen.dart';
import 'package:fakhama_amiradmin_app/features/products/screens/home_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../map/screens/home_map_screen.dart';
import '../../orders/screens/home_orders_screen.dart';
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
      title: 'products', // المنتجات
      icon: LucideIcons.package,
    ),
    NavigatorModel(
      title: 'map', // الخريطة
      icon: LucideIcons.mapPin,
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
    const HomeClientsScreen(),
    const HomeProductsScreen(),
    const HomeMapScreen(),
    const HomeOrdersScreen(),
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
