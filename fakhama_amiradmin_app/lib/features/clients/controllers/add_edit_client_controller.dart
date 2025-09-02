import 'package:fakhama_amiradmin_app/core/class/statusrequest.dart';
import 'package:fakhama_amiradmin_app/features/auth/models/user_model.dart';
import 'package:fakhama_amiradmin_app/features/clients/controllers/clients_controller.dart';
import 'package:fakhama_amiradmin_app/services/data/data_api.dart';
import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';

import '../../../core/constants/utils/widgets/snak_bar.dart';
import '../../../services/helper_function.dart';

class AddEditClientController extends GetxController {
  final DataApi dataApi = DataApi(Get.find());

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ClientsController clientsController = Get.find<ClientsController>();
  // Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  // Observable variables
  var statusRequest = StatusRequest.none.obs;
  var isEditMode = false.obs;
  var clientId = 0.obs;
  var isPasswordVisible = false.obs;
  var isActive = true.obs;

  // Current client data
  UserModel? currentClient;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      if (arguments.containsKey('client')) {
        isEditMode.value = true;
        currentClient = arguments['client'] as UserModel;
        clientId.value = currentClient!.id!;
        _fillFormWithClientData();
      }
    }
  }

  void _fillFormWithClientData() {
    if (currentClient != null) {
      usernameController.text = currentClient!.username;
      emailController.text = currentClient!.email;
      fullNameController.text = currentClient!.fullName;
      phoneController.text = currentClient!.phone;
      cityController.text = currentClient!.city ?? '';
      streetAddressController.text = currentClient!.streetAddress ?? '';
      countryController.text = currentClient!.country ?? '';
      latitudeController.text = currentClient!.latitude?.toString() ?? '';
      longitudeController.text = currentClient!.longitude?.toString() ?? '';
      isActive.value = currentClient!.isActive;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleActiveStatus() {
    isActive.value = !isActive.value;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال اسم المستخدم';
    }
    if (value.length < 3) {
      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!GetUtils.isEmail(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (!isEditMode.value) {
      if (value == null || value.isEmpty) {
        return 'يرجى إدخال كلمة المرور';
      }
      if (value.length < 6) {
        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      }
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال الاسم الكامل';
    }
    if (value.length < 2) {
      return 'الاسم الكامل يجب أن يكون حرفين على الأقل';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? validateLatitude(String? value) {
    if (value != null && value.isNotEmpty) {
      final lat = double.tryParse(value);
      if (lat == null || lat < -90 || lat > 90) {
        return 'خط العرض يجب أن يكون بين -90 و 90';
      }
    }
    return null;
  }

  String? validateLongitude(String? value) {
    if (value != null && value.isNotEmpty) {
      final lng = double.tryParse(value);
      if (lng == null || lng < -180 || lng > 180) {
        return 'خط الطول يجب أن يكون بين -180 و 180';
      }
    }
    return null;
  }

  Map<String, dynamic> _buildRequestData() {
    Map<String, dynamic> data = {
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'full_name': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'city': cityController.text.trim(),
      'street_address': streetAddressController.text.trim(),
      'country': countryController.text.trim(),
    };

    // Add password only if not in edit mode or if password is provided
    if (!isEditMode.value || passwordController.text.isNotEmpty) {
      data['password'] = passwordController.text;
    }

    // Add coordinates if provided
    if (latitudeController.text.isNotEmpty) {
      data['latitude'] = double.tryParse(latitudeController.text);
    }
    if (longitudeController.text.isNotEmpty) {
      data['longitude'] = double.tryParse(longitudeController.text);
    }

    return data;
  }

  Future<void> saveClient() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final data = _buildRequestData();

    await handleRequestfunc(
      hideLoading: false,
      status: (status) => statusRequest.value = status,
      apiCall: () async {
        if (isEditMode.value) {
          return await await dataApi.editCustomer(clientId.value, data);
        } else {
          return await dataApi.addCustomer(data);
        }
      },
      onSuccess: (res) {
        clientsController.fetchData(hideLoading: true);
        Get.back();
        showSnakBar(
            title: 'success'.tr,
            msg: isEditMode.value
                ? 'تم تحديث عميل بنجاح'.tr
                : 'تم إنشاء عميل بنجاح'.tr,
            color: Colors.green);
      },
      onError: showError,
    );
  }

  void clearForm() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    fullNameController.clear();
    phoneController.clear();
    cityController.clear();
    streetAddressController.clear();
    countryController.clear();
    latitudeController.clear();
    longitudeController.clear();
    isActive.value = true;
    isPasswordVisible.value = false;
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    streetAddressController.dispose();
    countryController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
