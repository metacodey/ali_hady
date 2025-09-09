import 'package:mc_utils/mc_utils.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/orders/screens/order_details_screen.dart';
import '../binding/home_binding.dart';
import '../../features/home/screen/home_screen.dart';
import '../middle_wares/middle_ware.dart';

List<GetPage<dynamic>> getPages = [
  GetPage(
      name: "/",
      page: () => const HomeScreen(),
      middlewares: [Middlewares()],
      binding: HomeBinding()),
  GetPage(
    name: "/login",
    binding: HomeBinding(),
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: "/order/details",
    binding: HomeBinding(),
    page: () => const OrderDetailsScreen(),
  ),
  // GetPage(
  //   name: "/client/add",
  //   binding: HomeBinding(),
  //   page: () => const AddEditClientScreen(),
  // ),
  // GetPage(
  //   name: "/product/add",
  //   binding: HomeBinding(),
  //   page: () => const AddEditProductScreen(),
  // ),
  // GetPage(
  //   name: "/order/add",
  //   binding: HomeBinding(),
  //   page: () => const AddOrderScreen(),
  // ),

  // GetPage(
  //   name: "/payments/add",
  //   binding: HomeBinding(),
  //   page: () => const AddEditPaymentScreen(),
  // ),
];
