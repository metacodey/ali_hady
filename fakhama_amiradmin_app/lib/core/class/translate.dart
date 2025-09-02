import 'package:mc_utils/mc_utils.dart';

class Messages extends Translations {
  final Map<String, Map<String, String>>? languages;
  Messages({required this.languages});

  @override
  Map<String, Map<String, String>> get keys {
    return languages!;
  }
}
