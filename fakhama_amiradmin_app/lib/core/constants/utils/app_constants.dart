import '../../../language/model/language.dart';
import 'assets/images.dart';

class AppConstants {
  static const String appName = ' ';
  static const String policyPage = '';
  static const String termsPage = "";
  static const String versionPage = '';
  static const String urlAppShare = "";

  /// Languages
  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: AppImages.arabic,
        languageName: 'عربى',
        countryCode: 'SA',
        languageCode: 'ar',
        rtl: true),
    LanguageModel(
        imageUrl: AppImages.english,
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),

    // LanguageModel(
    // imageUrl: AppImages.spanish,
    // languageName: 'Spanish',
    // countryCode: 'ES',
    // languageCode: 'es'),

    // LanguageModel(imageUrl: Images.bengali, languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
  ];
}
