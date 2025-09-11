import 'package:fakhama_amiradmin_app/features/clients/controllers/add_edit_client_controller.dart';
import 'package:fakhama_amiradmin_app/features/clients/controllers/clients_controller.dart';
import 'package:fakhama_amiradmin_app/features/conversations/controllers/chat_controller.dart';
import 'package:fakhama_amiradmin_app/features/map/controllers/map_app_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/add_edit_orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/orders/controllers/orders_controller.dart';
import 'package:fakhama_amiradmin_app/features/payments/controllers/add_edit_payment_controler.dart';
import 'package:fakhama_amiradmin_app/features/products/controllers/product_controller.dart';
import 'package:fakhama_amiradmin_app/services/socket_service.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/conversations/controllers/conversation_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/orders/controllers/order_details_controller.dart';
import '../../features/payments/controllers/payment_controller.dart';
import '../../features/products/controllers/add_edit_product_controller.dart';
import '../../services/api/api_client.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    //models
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ClientsController());
    Get.lazyPut(() => AddEditClientController());
    Get.lazyPut(() => MapAppController());
    Get.lazyPut(() => ProductController());
    Get.lazyPut(() => AddEditProductController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => AddEditOrdersController());
    Get.lazyPut(() => OrderDetailsController());
    Get.lazyPut(() => PaymentController());
    Get.lazyPut(() => AddEditPaymentControler());
    Get.lazyPut(() => ConversationController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => SocketService());
    // Get.lazyPut(() => PlanController());

    // Get.lazyPut(() => JournalController());
    // Get.lazyPut(() => AccountStatementController());
  }
}
