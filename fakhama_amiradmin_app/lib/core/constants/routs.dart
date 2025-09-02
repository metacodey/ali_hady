import 'package:fakhama_amiradmin_app/features/auth/screens/login_screen.dart';
import 'package:fakhama_amiradmin_app/features/clients/screens/add_edit_client.dart';
import 'package:mc_utils/mc_utils.dart';
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
];
