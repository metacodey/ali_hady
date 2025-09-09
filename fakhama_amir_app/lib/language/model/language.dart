class LanguageModel {
  final String? imageUrl;
  final String? languageName;
  final String? languageCode;
  final String? countryCode;
  final bool rtl;

  const LanguageModel(
      {this.imageUrl,
      this.languageName,
      this.countryCode,
      this.languageCode,
      this.rtl = false});
}
