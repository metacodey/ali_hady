import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mc_utils/mc_utils.dart';
// import '../../firebase_options.dart';
import '../../firebase_options.dart';
import '../../language/controller/localization_controller.dart';
import '../../language/model/language.dart';
import '../../services/notifications/notifcations_service.dart';
import '../../theme/controller/theme_controller.dart';
import '../class/preferences.dart';
import '../constants/utils/app_constants.dart';
import '../controller/connect_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<Map<String, Map<String, String>>> init() async {
  Get.put(ConnectController(), permanent: true);
  Get.lazyPut(() => LocalizationController());
  Get.lazyPut(() => ThemeController());
  await Preferences.initPref();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ar', null);
  notificationService.init();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //languague
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/lang/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
