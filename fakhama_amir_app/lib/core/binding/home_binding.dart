import 'package:mc_utils/mc_utils.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/home/controller/home_controller.dart';
import '../../features/orders/controllers/order_details_controller.dart';
import '../../features/orders/controllers/orders_controller.dart';
import '../../services/api/api_client.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    //models
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => OrderDetailsController());
    // Get.lazyPut(() => ClientsController());
    // Get.lazyPut(() => AddEditClientController());
    // Get.lazyPut(() => MapAppController());
    // Get.lazyPut(() => ProductController());
    // Get.lazyPut(() => AddEditProductController());
    // Get.lazyPut(() => AddEditOrdersController());

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
