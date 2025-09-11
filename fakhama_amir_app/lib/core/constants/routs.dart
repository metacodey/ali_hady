import 'package:fakhama_amir_app/features/conversations/screens/add_conversation_screen.dart';
import 'package:fakhama_amir_app/features/conversations/screens/chat_screen.dart';
import 'package:fakhama_amir_app/features/profile/screens/home_profile_screen.dart';
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
  GetPage(
    name: "/client/profile",
    binding: HomeBinding(),
    page: () => const HomeProfileScreen(),
  ),
  GetPage(
    name: "/chat/add",
    binding: HomeBinding(),
    page: () => const AddConversationScreen(),
  ),
  GetPage(
    name: "/chat/chat",
    binding: HomeBinding(),
    page: () => const ChatScreen(),
  ),

  // GetPage(
  //   name: "/payments/add",
  //   binding: HomeBinding(),
  //   page: () => const AddEditPaymentScreen(),
  // ),
];
