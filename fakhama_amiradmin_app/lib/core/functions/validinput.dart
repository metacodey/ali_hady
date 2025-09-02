import 'package:mc_utils/mc_utils.dart';
import '../class/validate_types.dart';

validInput(
    {String val = "",
    bool isNull = false,
    int? min,
    int? max,
    double? maxValue,
    String? name,
    ValidateTypes type = ValidateTypes.none}) {
  if (isNull && val.isEmpty) {
    return null;
  }
  if (!isNull && val.isEmpty) {
    return '${"empty".tr} ${name != null ? name.tr : "value".tr}';
  }

  if (min != null && val.length < min) {
    return "${"bigger".tr} $min";
  }

  if (max != null && val.length > max) {
    return "${"less".tr} $max";
  }
  if (type.isUserName) {
    if (!GetUtils.isUsername(val)) {
      return "user_name_error".tr;
    }
  }
  if (type.isName) {
    if (!GetUtils.isUsername(val)) {
      return "name_error".tr;
    }
  }
  if (type.isNumber) {
    if (!McProcess.cheCkContainNumber(val)) {
      return "numeric_error".tr;
    }
  }
  if (type.isEmail) {
    if (!GetUtils.isEmail(val)) {
      return "enter_a_valid_email_address".tr;
    }
  }

  if (type.isPhone) {
    if (!GetUtils.isPhoneNumber(val)) {
      return "invalid_phone_number".tr;
    }
  }
  if (maxValue != null) {
    var totel = double.tryParse(val) ?? 100;
    if (totel > maxValue) {
      return "${"max_value".tr} $maxValue%";
    }
  }
  // if (type.isPassword) {
  //   if (!GetUtils.isPassport(val)) {
  //     return "password_should_be".tr;
  //   }
  // }
}
