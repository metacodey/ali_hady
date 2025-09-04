class ApiServices {
  static String server = "http://192.168.1.71:3000/api/";

  static const headers = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };

  // Auth endpoints
  static String customerLogin = "${server}auth/customer/login";
  static String userLogin = "${server}auth/user/login";
  static String customerRegister = "${server}auth/customer/register";
  static String verifyToken = "${server}auth/verify";
  static String changePassword = "${server}auth/change-password";
  static String forgotPassword = "${server}auth/forgot-password";

  // Customer endpoints
  static String customersList = "${server}customers";
  static String showCustomer = "${server}customers/";
  static String mapCustomer = "${server}customers/map";
  static String addCustomer = "${server}customers";
  static String editCustomer = "${server}customers/";
  static String deleteCustomer = "${server}customers/";
  static String customersStats = "${server}customers/dashboard/stats";

  // Product endpoints
  static String productsList = "${server}products";
  static String productsAll = "${server}products/all";
  static String productsAdmin = "${server}products/admin";
  static String showProduct = "${server}products/";
  static String addProduct = "${server}products";
  static String editProduct = "${server}products/";
  static String deleteProduct = "${server}products/";
  static String productsAdvancedSearch = "${server}products/search/advanced";
  static String productCategories = "${server}products/categories/list";
  static String productsStats = "${server}products/dashboard/stats";

  // Order endpoints
  static String ordersList = "${server}orders";
  static String myOrders = "${server}orders/my";
  static String showOrder = "${server}orders/";
  static String addOrder = "${server}orders";
  static String updateOrderStatus = "${server}orders/";
  static String deleteOrder = "${server}orders/";
  static String ordersStats = "${server}orders/dashboard/stats";
  static String statusOrders = "${server}orders/status";
  static String customersOrders = "${server}orders/customers";

  // Payment endpoints
  static String paymentsList = "${server}payments";
  static String orderPayments = "${server}payments/order/";
  static String showPayment = "${server}payments/";
  static String addPayment = "${server}payments";
  static String updatePaymentStatus = "${server}payments/";
  static String deletePayment = "${server}payments/";
  static String paymentMethods = "${server}payments/methods/list";
  static String paymentsStats = "${server}payments/dashboard/stats";

  // User endpoints
  static String usersList = "${server}users";
  static String userProfile = "${server}users/profile";
  static String showUser = "${server}users/";
  static String addUser = "${server}users";
  static String editUser = "${server}users/";
  static String updateProfile = "${server}users/profile/update";
  static String deleteUser = "${server}users/";

  // Conversation endpoints
  static String conversationsList = "${server}conversations";
  static String myConversations = "${server}conversations/my";
  static String showConversation = "${server}conversations/";
  static String addConversation = "${server}conversations";
  static String assignConversation = "${server}conversations/";
  static String updateConversationStatus = "${server}conversations/";
  static String deleteConversation = "${server}conversations/";
  static String conversationsStats = "${server}conversations/dashboard/stats";
}
