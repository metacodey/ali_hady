import 'package:fakhama_amiradmin_app/features/clients/controllers/add_edit_client_controller.dart';
import 'package:fakhama_amiradmin_app/features/clients/controllers/clients_controller.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../features/auth/controllers/login_controller.dart';
import '../../features/home/controller/home_controller.dart';
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
    // Get.lazyPut(() => InvoiceController());
    // Get.lazyPut(() => PaymentController());
    // Get.lazyPut(() => ReturnController());
    // Get.lazyPut(() => StatisticsController());
    // Get.lazyPut(() => InvoiceController());
    // Get.lazyPut(() => AddEditInvoiceController());
    // Get.lazyPut(() => AddJournalInvoiceController());
    // Get.lazyPut(() => AddJournalController());
    // Get.lazyPut(() => ExpandableFabController());
    // Get.lazyPut(() => ExpandableFabController(), tag: "home_invoice");
    // Get.lazyPut(() => UserController());
    // Get.lazyPut(() => PlanController());

    // Get.lazyPut(() => JournalController());
    // Get.lazyPut(() => AccountStatementController());
  }
}
