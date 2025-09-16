import '../../core/class/preferences.dart';
import '../api/api_client.dart';
import '../api/api_services.dart';

class DataApi {
  ApiClient apiReq;
  DataApi(this.apiReq);

  Map<String, String>? _headerWithToken() {
    var user = Preferences.getDataUser();
    if (user != null) {
      var token = user.token;
      return {"Authorization": "Bearer $token"};
    }
    return null;
  }

  Map<String, String>? get header => _headerWithToken();

  // Customer Methods
  getCustomersList({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.customersList}?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  showCustomer(int customerId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showCustomer}$customerId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getDataMap() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.mapCustomer,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  addCustomer(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addCustomer,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  editCustomer(int customerId, Map<String, dynamic> data) async {
    var res = await apiReq.updateJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.editCustomer}$customerId",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteCustomer(int customerId) async {
    var res = await apiReq.deleteData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.deleteCustomer}$customerId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getCustomersStats() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.customersStats,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  // Product Methods
  getProductsList({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.productsList}?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getProductsAdmin({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.productsAdmin}?$queryString",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  showProduct(int productId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showProduct}$productId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  addProduct(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addProduct,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  editProduct(int productId, Map<String, dynamic> data) async {
    var res = await apiReq.updateJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.editProduct}$productId",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteProduct(int productId) async {
    var res = await apiReq.deleteData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.deleteProduct}$productId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  searchProductsAdvanced(
      {String? q,
      int? category,
      double? minPrice,
      double? maxPrice,
      bool? inStock,
      int page = 1,
      int limit = 10}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (q != null && q.isNotEmpty) queryParams['q'] = q;
    if (category != null) queryParams['category'] = category.toString();
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
    if (inStock != null) queryParams['in_stock'] = inStock.toString();

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.productsAdvancedSearch}?$queryString",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getProductCategories() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.productCategories,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getProductsStats() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.productsStats,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  // Order Methods
  getOrdersList({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.ordersList}?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getStatus() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.statusOrders,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getCustomersOrders() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.customersOrders,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getProductsOrders() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.productsAll,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getOrdersIncomplete() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.ordersIncomplete,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getMyOrders({int page = 1, int limit = 10}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.myOrders}?$queryString",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  showOrder(int orderId) async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.showOrder}$orderId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  addOrder(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addOrder,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  updateOrderStatus(int orderId, Map<String, dynamic> data) async {
    var res = await apiReq.updateJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.updateOrderStatus}$orderId/status",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteOrder(int orderId) async {
    var res = await apiReq.deleteData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.deleteOrder}$orderId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getOrdersStats() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.ordersStats,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  // Payment Methods
  getPaymentsList({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.paymentsList}?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getOrderPayments(int orderId) async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.orderPayments}$orderId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  showPayment(int paymentId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showPayment}$paymentId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  addPayment(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addPayment,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  updatePaymentStatus(int paymentId, Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.updatePaymentStatus}$paymentId/status",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deletePayment(int paymentId) async {
    var res = await apiReq.deleteData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.deletePayment}$paymentId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getPaymentMethods() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.paymentMethods,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getPaymentsStats() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.paymentsStats,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  // User Methods
  getUsersList({int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.usersList}?$queryString",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getUserProfile() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.userProfile,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  showUser(int userId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showUser}$userId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  addUser(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addUser,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  editUser(int userId, Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.editUser}$userId",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  updateProfile(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.updateProfile,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteUser(int userId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.deleteUser}$userId",
        method: "DELETE");
    return res.fold((lef) => lef, (re) => re);
  }

  // Conversation Methods
  getConversationsList(
      {int page = 1, int limit = 10, String search = ''}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.conversationsList}?$queryString",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  getCustomerConversation(
      {required int idCustomer, int page = 1, int limit = 10}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.customerConversation}$idCustomer?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getMyConversations({int page = 1, int limit = 10}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.myConversations}?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  showConversation(int conversationId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showConversation}$conversationId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  addConversation(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addConversation,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  addConversationByAdmin(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addConversationByAdmin,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  assignConversation(int conversationId, Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.assignConversation}$conversationId/assign",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  updateConversationStatus(
      int conversationId, Map<String, dynamic> data) async {
    var res = await apiReq.updateJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.updateConversationStatus}$conversationId/status",
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteConversation(int conversationId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.deleteConversation}$conversationId",
        method: "DELETE");
    return res.fold((lef) => lef, (re) => re);
  }

  getConversationsStats() async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: ApiServices.conversationsStats,
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  // Message Methods
  getConversationMessages(int conversationId,
      {int page = 1, int limit = 10}) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    String queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.conversationMessages}$conversationId?$queryString",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  addMessage(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.addMessage,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  showMessage(int messageId) async {
    var res = await apiReq.dynamicData(
        headers: _headerWithToken() ?? {},
        url: "${ApiServices.showMessage}$messageId",
        method: "GET");
    return res.fold((lef) => lef, (re) => re);
  }

  markMessageAsRead(int messageId) async {
    var res = await apiReq.updateJsonData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.markMessageRead}$messageId/read",
      data: {},
    );
    return res.fold((lef) => lef, (re) => re);
  }

  deleteMessage(int messageId) async {
    var res = await apiReq.deleteData(
      headers: _headerWithToken() ?? {},
      url: "${ApiServices.deleteMessage}$messageId",
    );
    return res.fold((lef) => lef, (re) => re);
  }

  getUnreadMessagesCount() async {
    var res = await apiReq.fetchJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.unreadMessagesCount,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  markAllMessagesAsRead(Map<String, dynamic> data) async {
    var res = await apiReq.sendJsonData(
      headers: _headerWithToken() ?? {},
      url: ApiServices.markAllMessagesRead,
      data: data,
    );
    return res.fold((lef) => lef, (re) => re);
  }
}
