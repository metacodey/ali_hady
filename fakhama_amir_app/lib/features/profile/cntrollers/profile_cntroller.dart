import 'package:mc_utils/mc_utils.dart';

import '../../../core/class/preferences.dart';
import '../../../core/class/statusrequest.dart';
import '../../../services/data/data_api.dart';
import '../../../services/helper_function.dart';
import '../../auth/models/user_model.dart';

class ProfileCntroller extends GetxController {
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  Rx<UserModel?> userModel = Preferences.getDataUser().obs;
  final DataApi dataApi = DataApi(Get.find());

  Future<void> getMyData() async {
    var user = Preferences.getDataUser();
    await handleRequestfunc(
      status: (status) => statusRequest.value = status,
      apiCall: () async => await dataApi.showCustomer(user!.id!),
      hideLoading: true,
      onSuccess: (res) {
        var data = res['data'];
        userModel.value = UserModel.fromJson(data);
        userModel.value = userModel.value?.copyWith(token: user?.token ?? "");
        Preferences.setDataUser(userModel.value!);
      },
      onError: showError,
    );
  }

  @override
  void onInit() {
    getMyData();
    super.onInit();
  }

  void logout() {
    Preferences.clearDataUser();
    Get.offAllNamed('/');
  }
}
