import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/preferences.dart';
import '../../core/constants/utils/app_constants.dart';
import '../model/language.dart';

class LocalizationController extends GetxController implements GetxService {
  // final LanguageServiceInterface languageServiceInterface;
  LocalizationController() {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!,
      AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;
  List<Locale> get languagesLocals {
    return languages.isEmpty
        ? []
        : languages
            .map(
              (e) => Locale(e.languageCode!, e.countryCode),
            )
            .toList();
  }

  void setLanguage(Locale locale, {bool fromBottomSheet = false}) {
    Get.updateLocale(locale);
    _locale = locale;
    if (!fromBottomSheet) {
      saveCacheLanguage(_locale);
    }
    update();
  }

  void loadCurrentLanguage() async {
    if (Preferences.getString(Preferences.localLange).isNotEmpty) {
      var index = AppConstants.languages.indexWhere(
        (element) =>
            element.countryCode ==
            (Preferences.getString(Preferences.localLange)),
      );
      _locale = Locale(
        AppConstants.languages[index].languageCode!,
        AppConstants.languages[index].countryCode,
      );
      _selectedIndex = index;
    }
    _isLtr = _locale.languageCode != 'ar';

    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveCacheLanguage(Locale locale) async {
    Preferences.setString(Preferences.localLange, locale.countryCode ?? 'ar');
    _locale = locale;
    Get.updateLocale(locale);
  }

  void setSelectIndex(int index) async {
    _selectedIndex = index;
    _locale =
        Locale(languages[index].languageCode!, languages[index].countryCode);
    Get.updateLocale(_locale);
  }
}
