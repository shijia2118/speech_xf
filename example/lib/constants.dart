const String appId = "e47801bc"; //这里是你在讯飞平台申请的appid

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

const kSpeechSynthesisDefaultText =
    "科大讯飞作为智能语音技术供应商，在智能语音技术领域有着长期的研究积累，并在中文语音合成、语音识别、口语评测等多项技术上拥有技术成果。科大讯飞是我国以语言技术为产业化方向的'国家863计划产业化基地。'";

///音频流类型
const kStreamTypes = ['通话', '系统', '铃声', '音乐', '闹铃', '通知'];

///发音人列表
const kVoicerList = {
  'xiaoyan': '小燕—女青、中英、普通话',
  'xiaoyu': '小宇—男青、中英、普通话',
  'catherine': '凯瑟琳—女青、英',
  'henry': '亨利—男青、英',
  'vimary': '玛丽—女青、英',
  'vixy': '小研—女青、中英、普通话',
  'xiaoqi': '小琪—女青、中英、普通话',
  'vixf': '小峰—男青、中英、普通话',
  'xiaomei': '小梅—女青、中英、粤语',
  'xiaolin': '小莉—女青、中英、台湾普通话',
  'xiaorong': '小蓉—女青、中、四川话',
  'xiaoqian': '小芸—女青、中、东北话',
  'xiaokun': '小坤—男青、中、河南话',
  'xiaoqiang': '小强—男青、中、湖南话',
  'vixying': '小莹—女青、中、陕西话',
  'xiaoxin': '小新—男童、中、普通话',
  'nannan': '楠楠—女童、中、普通话',
  'vils': '老孙—男老、中、普通话',
};
