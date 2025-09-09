import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/models/user_model.dart';

// import '../../features/auth/model/user.dart';

class Preferences {
  static const isLogin = "isLogin";
  static const showSplash = "showSplash";
  static const user = "user";
  static const localLange = "LOCALE";
  static const themeApp = "THEME";
  static const locationApp = "LOCATION";
  static const notificationApp = "NOTIFICATION";
  static const onboardingCompleted = "onboardingCompleted";

  static late SharedPreferences pref;

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  static bool getBoolean(String key) {
    return pref.getBool(key) ?? false;
  }

  static Future<void> setBoolean(String key, bool value) async {
    await pref.setBool(key, value);
  }

  static String getString(String key) {
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    await pref.setString(key, value);
  }

  static Future<void> setListString(String key, List<String>? value) async {
    await pref.setStringList(key, value ?? []);
  }

  static List<String> getListString(String key) {
    return pref.getStringList(key) ?? [];
  }

  static int getInt(String key) {
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setInt(String key, int value) async {
    await pref.setInt(key, value);
  }

  static Future<void> clearSharPreference() async {
    await pref.clear();
  }

  static Future<void> clearKeyData(String key) async {
    await pref.remove(key);
  }

  static Future<void> clearDataUser() async {
    await pref.remove(isLogin);
    await pref.remove(user);
  }

  static Future<void> setDataUser(UserModel userModel) async {
    // log("${userModel.toJson()}8888888888888888888888");
    var userEncode = jsonEncode(userModel.toJson());
    await pref.setString(user, userEncode);
  }

  static UserModel? getDataUser() {
    var data = pref.getString(user);
    if (data != null && data.isNotEmpty) {
      var userDecode = jsonDecode(data);
      UserModel userModel = UserModel.fromJson(userDecode);

      return userModel;
    } else {
      return null;
    }
  }
}
