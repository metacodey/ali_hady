import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mc_utils/mc_utils.dart';
import 'core/class/translate.dart';
import 'core/constants/routs.dart';
import 'core/constants/utils/app_constants.dart';
import 'core/helper/get_di.dart' as di;
import 'language/controller/localization_controller.dart';
import 'theme/controller/theme_controller.dart';
import 'theme/theme/dark_theme.dart';
import 'theme/theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(
    languages: languages,
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  const MyApp({super.key, this.languages});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) =>
            GetBuilder<ThemeController>(builder: (themeController) {
              return GetBuilder<LocalizationController>(
                  builder: (localizeController) {
                return GetMaterialApp(
                  builder: EasyLoading.init(),
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    DefaultMaterialLocalizations.delegate,
                    DefaultCupertinoLocalizations.delegate,
                    DefaultWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: localizeController.languagesLocals,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  themeMode: ThemeMode.system,
                  theme: themeController.darkTheme ? dark : light,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  defaultTransition: Transition.topLevel,
                  initialRoute: '/',
                  getPages: getPages,
                );
              });
            }));
  }
}
