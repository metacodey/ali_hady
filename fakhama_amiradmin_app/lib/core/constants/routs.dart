import 'package:fakhama_amiradmin_app/features/auth/screens/login_screen.dart';
import 'package:fakhama_amiradmin_app/features/clients/screens/add_edit_client.dart';
import 'package:fakhama_amiradmin_app/features/orders/screens/add_order_screen.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../features/products/screens/add_edit_product.dart';
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
    name: "/client/add",
    binding: HomeBinding(),
    page: () => const AddEditClientScreen(),
  ),
  GetPage(
    name: "/product/add",
    binding: HomeBinding(),
    page: () => const AddEditProductScreen(),
  ),
  GetPage(
    name: "/order/add",
    binding: HomeBinding(),
    page: () => const AddOrderScreen(),
  ),
];
