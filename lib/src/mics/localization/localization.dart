import 'package:dropin/src_exports.dart';

import 'en_us.dart';

class LocalizationService extends Translations {
  static Locale? _locale;

  static Locale? get locale => _locale ?? Get.deviceLocale;
  static const Locale fallbackLocale = Locale('en', 'US');

  static final List<Map<String, Object>> localeList = <Map<String, Object>>[
    <String, Object>{'name': 'English', 'locale': const Locale('en', 'US')},
  ];

  @override
  Map<String, Map<String, String>> get keys =>
      <String, Map<String, String>>{'en_US': en_us};
}
