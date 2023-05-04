import 'speech_xf_platform_interface.dart';

class SpeechXf {
  /// 初始化
  static Future init(String appId) {
    return SpeechXfPlatform.instance.init(appId);
  }

  /// 显示内置语音识别对话框
  /// 返回语音转写后的字符串
  /// 参数说明：
  /// [isDynamicCorrection]：是否开启动态修正。
  /// 未开启动态修正：每次返回的结果都是对之前结果的追加；
  /// 开启动态修正：每次返回的结果有可能是对之前结果的的追加，也有可能是要替换之前某次返回的结果（即修正）；
  /// 相较于未开启，返回结果的颗粒度更小，视觉冲击效果更佳；
  /// 使用动态修正功能需到控制台-流式听写-高级功能处点击开通.并将参数`isDynamicCorrection`设置为true.
  /// 目前SDK仅在中文下支持动态修正。
  /// [language] :设置语言。
  /// Android端目前仅支持7种语言:中文、英文、日语、韩语、俄语、法语和西班牙语.
  /// 注：小语种若未授权无法使用会报错11200，可到控制台-语音听写（流式版）-方言/语种处添加试用或购买。
  /// [vadBos] :前端点检测
  /// 开始录入音频后，音频前面部分最长静音时长，取值范围[0,10000ms]，默认值5000ms.
  /// [vadEos] :后端点检测
  /// 开始录入音频后，音频后面部分最长静音时长，取值范围[0,10000ms]，默认值1800ms。
  /// [ptt] :标点符号
  /// 1-有标点；0-无标点 默认为1
  static Future<String?> openNativeUIDialog({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) {
    return SpeechXfPlatform.instance.openNativeUIDialog(
      isDynamicCorrection: isDynamicCorrection,
      language: language,
      vadBos: vadBos,
      vadEos: vadEos,
      ptt: ptt,
    );
  }

  /// 开始听写（无UI）
  /// 参数同上
  static Future<String?> startListening({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) {
    return SpeechXfPlatform.instance.startListening(
      isDynamicCorrection: isDynamicCorrection,
      language: language,
      vadBos: vadBos,
      vadEos: vadEos,
      ptt: ptt,
    );
  }

  /// 停止听写
  static Future stopListening() async {
    return SpeechXfPlatform.instance.stopListening();
  }

  /// 取消听写
  static Future cancelListening() async {
    return SpeechXfPlatform.instance.cancelListening();
  }

  /// 上传用户级热词
  /// 与应用级热词相对。
  /// 一般上传后10分钟左右生效，影响的范围是，当前 APPID 应用的当前设备——即同一应用，不同设备里上传的热词互不干扰；
  /// 同一设备，不同APPID的应用上传的热词互不干扰。
  /// 如果需要设置应用级热词，可以前往"讯飞开放平台官网—控制台 —个性化热词设置".
  /// 上传后1-2小时后生效，应用级热词是对所有运行你应用的设备都生效，更新给当前APPID的所有使用设备。
  static Future<void> uploadUserWords(String contents) {
    return SpeechXfPlatform.instance.uploadUserWords(contents);
  }

  /// 音频流识别
  /// [path] :音频流地址
  static Future<String?> audioRecognizer(String path) {
    return SpeechXfPlatform.instance.audioRecognizer(path);
  }
}
