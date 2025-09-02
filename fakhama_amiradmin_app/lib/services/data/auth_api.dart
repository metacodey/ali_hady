import '../api/api_client.dart';
import '../api/api_services.dart';

class AuthApi {
  ApiClient apiReq;
  AuthApi(this.apiReq);

  // Customer register
  customerRegister({required Map<String, String> data}) async {
    var res = await apiReq.sendJsonData(
        url: ApiServices.customerRegister, data: data);
    return res.fold((lef) => lef, (re) => re);
  }

  // Customer login
  customerLogin({required Map<String, String> data}) async {
    var res =
        await apiReq.sendJsonData(url: ApiServices.customerLogin, data: data);
    return res.fold((lef) => lef, (re) => re);
  }

  // User/Admin login
  userLogin({
    required String email,
    required String password,
  }) async {
    var res = await apiReq.sendJsonData(url: ApiServices.userLogin, data: {
      "email": email,
      "password": password,
    });
    return res.fold((lef) => lef, (re) => re);
  }

  // Verify token
  verifyToken() async {
    var res = await apiReq.fetchJsonData(
      url: ApiServices.verifyToken,
    );
    return res.fold((lef) => lef, (re) => re);
  }

  // Change password
  changePassword({required Map<String, String> data}) async {
    var res =
        await apiReq.sendJsonData(url: ApiServices.changePassword, data: data);
    return res.fold((lef) => lef, (re) => re);
  }

  // Forgot password
  forgotPassword({required Map<String, String> data}) async {
    var res =
        await apiReq.sendJsonData(url: ApiServices.forgotPassword, data: data);
    return res.fold((lef) => lef, (re) => re);
  }
}
