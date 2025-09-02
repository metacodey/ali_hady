import 'package:flutter/material.dart';
import 'package:mc_utils/mc_utils.dart';
import '../class/preferences.dart';

class Middlewares extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // التحقق من إكمال Onboarding أولاً
    // if (Preferences.getString(Preferences.localLange).isEmpty) {
    //   return const RouteSettings(name: "/lang");
    // }

    if (!Preferences.getBoolean(Preferences.isLogin)) {
      return const RouteSettings(name: "/login");
    }
    return null;
  }
}
