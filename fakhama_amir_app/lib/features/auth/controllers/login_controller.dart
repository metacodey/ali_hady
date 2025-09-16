import 'package:fakhama_amir_app/services/notifications/notifcations_service.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../../../core/class/preferences.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/auth_api.dart';
import '../../../services/helper_function.dart';
import '../models/user_model.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  final AuthApi authApi = AuthApi(Get.find());

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;
    var tokenFirebase = await NotificationService.getToken();
    await handleRequestfunc(
      status: (status) {
        statusRequest.value = status;
      },
      apiCall: () async {
        return await authApi.customerLogin(
            email: emailController.text,
            password: passwordController.text,
            tokenFirebase: tokenFirebase);
      },
      onSuccess: (res) {
        var data = res['data'];
        var model = UserModel.fromJson(data['user']);
        model = model.copyWith(token: data['token']);
        Preferences.setDataUser(model);
        Preferences.setBoolean(Preferences.isLogin, true);
        Get.offAllNamed('/');
      },
      onError: showError,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    // emailController.text = "email@gmail.com";
    // passwordController.text = "admin123";
    super.onInit();
  }
}
