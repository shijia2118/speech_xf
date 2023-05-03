const List<Map<String, String>> kLanguages = [
  {'zh_cn': "中文"},
  {'en_us': '英文'},
  {'ja_jp': '日语'},
  {'ko_kr': '韩语'},
  {'ru-ru': '俄语'},
  {'fr_fr': '法语'},
  {'es_es': '西班牙语'},
];

extension LanguageKey on String {
  static String? of(String languageValue) {
    switch (languageValue) {
      case '中文':
        return 'zh_cn';
      case '英文':
        return 'en_us';
      case '日语':
        return 'ja_jp';
      case '韩语':
        return 'ko_kr';
      case '俄语':
        return 'ru-ru';
      case '法语':
        return 'fr_fr';
      case '西班牙语':
        return 'es_es';
      default:
        return null;
    }
  }
}

extension LanguageValue on String {
  static String? of(String? languageKey) {
    switch (languageKey) {
      case 'zh_cn':
        return '中文';
      case 'en_us':
        return '英文';
      case 'ja_jp':
        return '日语';
      case 'ko_kr':
        return '韩语';
      case 'ru-ru':
        return '俄语';
      case 'fr_fr':
        return '法语';
      case 'es_es':
        return '西班牙语';
      default:
        return null;
    }
  }
}

extension GetPttKey on String {
  static String? of(String? value) {
    switch (value) {
      case '有':
        return '1';
      case '无':
        return '0';
      default:
        return '1';
    }
  }
}

extension GetPttValue on String {
  static String? of(String? key) {
    switch (key) {
      case '1':
        return '有';
      case '0':
        return '无';
      default:
        return null;
    }
  }
}
