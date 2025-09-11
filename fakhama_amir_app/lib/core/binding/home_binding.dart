import 'package:fakhama_amir_app/features/profile/cntrollers/profile_cntroller.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/conversations/controllers/add_conversation_controller.dart';
import '../../features/conversations/controllers/chat_controller.dart';
import '../../features/conversations/controllers/conversation_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/orders/controllers/order_details_controller.dart';
import '../../features/orders/controllers/orders_controller.dart';
import '../../features/payments/controllers/payment_controller.dart';
import '../../services/api/api_client.dart';
import '../../services/socket_service.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    //models
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => OrderDetailsController());
    Get.lazyPut(() => ProfileCntroller());
    Get.lazyPut(() => PaymentController());
    Get.lazyPut(() => ConversationController());
    Get.lazyPut(() => AddConversationController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => SocketService());

    // Get.lazyPut(() => PaymentController());
    // Get.lazyPut(() => AddEditPaymentControler());
    // // Get.lazyPut(() => ExpandableFabController());
    // Get.lazyPut(() => ExpandableFabController(), tag: "home_invoice");
    // Get.lazyPut(() => UserController());
    // Get.lazyPut(() => PlanController());

    // Get.lazyPut(() => JournalController());
    // Get.lazyPut(() => AccountStatementController());
  }
}
