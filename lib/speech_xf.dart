import 'dart:async';

import 'package:flutter/services.dart';
import 'package:speech_xf/speech_result.dart';

class SpeechXf {
  static const methodChannel = MethodChannel('xf_speech_to_text');

  static const iatEventChannel = EventChannel('xf_speech_to_text_stream');

  static const ttsEventChannel = EventChannel('xf_text_to_speech_stream');

  static Stream<Map<String, Object>> onGetResult = iatEventChannel
      .receiveBroadcastStream()
      .asBroadcastStream()
      .map<Map<String, Object>>((element) => element.cast<String, Object>());

  static Stream<void> onGetTtsResult = ttsEventChannel.receiveBroadcastStream().asBroadcastStream();

  StreamController<SpeechResult>? receiveStream;
  StreamSubscription<Map<String, Object>>? subscription;

  StreamController<void>? receiveTtsStream;
  StreamSubscription<void>? ttsSubscription;

  /// 获取翻译结果流
  Stream<SpeechResult> onResult() {
    if (receiveStream == null) {
      receiveStream = StreamController();
      subscription = onGetResult.listen((Map<String, Object> event) {
        Map<String, Object> newEvent = Map<String, Object>.of(event);
        receiveStream?.add(SpeechResult.fromJson(newEvent));
      });
    }
    return receiveStream!.stream;
  }

  /// 语音播放结束回调
  Stream<void> onCompeleted() {
    if (receiveTtsStream == null) {
      receiveTtsStream = StreamController();
      ttsSubscription = onGetTtsResult.listen((event) {
        receiveTtsStream?.add(event);
      });
    }
    return receiveTtsStream!.stream;
  }

  /// 初始化
  static Future init(String appId) async {
    Map<String, dynamic> arguments = {'appId': appId};
    return await methodChannel.invokeMethod('init', arguments);
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
  }) async {
    Map<String, dynamic> arguments = {
      'isDynamicCorrection': isDynamicCorrection,
      'language': language,
      'vadBos': vadBos,
      'vadEos': vadEos,
      'ptt': ptt,
    };
    return await methodChannel.invokeMethod('open_native_ui_dialog', arguments);
  }

  /// 开始听写（无UI）
  /// 参数同上
  static Future<void> startListening({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) async {
    Map<String, dynamic> arguments = {
      'isDynamicCorrection': isDynamicCorrection,
      'language': language,
      'vadBos': vadBos,
      'vadEos': vadEos,
      'ptt': ptt,
    };
    return await methodChannel.invokeMethod('start_listening', arguments);
  }

  /// 停止听写
  static Future stopListening() async {
    return await methodChannel.invokeMethod('stop_listening');
  }

  /// 取消听写
  static Future cancelListening() async {
    return await methodChannel.invokeMethod('cancel_listening');
  }

  /// 上传用户级热词
  /// 与应用级热词相对。
  /// 一般上传后10分钟左右生效，影响的范围是，当前 APPID 应用的当前设备——即同一应用，不同设备里上传的热词互不干扰；
  /// 同一设备，不同APPID的应用上传的热词互不干扰。
  /// 如果需要设置应用级热词，可以前往"讯飞开放平台官网—控制台 —个性化热词设置".
  /// 上传后1-2小时后生效，应用级热词是对所有运行你应用的设备都生效，更新给当前APPID的所有使用设备。
  static Future<void> uploadUserWords(String contents) async {
    Map<String, dynamic> arguments = {'contents': contents};
    return await methodChannel.invokeMethod('upload_user_words', arguments);
  }

  /// 音频流识别
  /// [path] :音频流地址
  static Future<String?> audioRecognizer(String path) async {
    Map<String, dynamic> arguments = {'path': path};
    return await methodChannel.invokeMethod('audio_recognizer', arguments);
  }

  /// 开始语音合成
  /// [volume] :音量,范围(0~100),默认50;
  /// [speed] :语速,范围(0~100),默认50;
  /// [pitch] :语调,范围(0~100),默认50;
  /// [streamType] :音频流类型，默认为音乐;
  /// [content] :播放内容;
  /// [voiceName] :发音人,默认"小燕".每个发音人有对应的性别，语种和方言。具体可参照demo中
  /// 的发音人列表。
  /*
 *  云端支持如下发音人：
 *  对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。
 *
 *  |--------|----------------|
 *  |  发音人 |  参数          |
 *  |--------|----------------|
 *  |  小燕   |   xiaoyan     |
 *  |--------|----------------|
 *  |  小宇   |   xiaoyu      |
 *  |--------|----------------|
 *  |  凯瑟琳 |   catherine   |
 *  |--------|----------------|
 *  |  亨利   |   henry       |
 *  |--------|----------------|
 *  |  玛丽   |   vimary      |
 *  |--------|----------------|
 *  |  小研   |   vixy        |
 *  |--------|----------------|
 *  |  小琪   |   vixq        |
 *  |--------|----------------|
 *  |  小峰   |   vixf        |
 *  |--------|----------------|
 *  |  小梅   |   vixl        |
 *  |--------|----------------|
 *  |  小莉   |   vixq        |
 *  |--------|----------------|
 *  |  小蓉   |   vixr        |
 *  |--------|----------------|
 *  |  小芸   |   vixyun      |
 *  |--------|----------------|
 *  |  小坤   |   vixk        |
 *  |--------|----------------|
 *  |  小强   |   vixqa       |
 *  |--------|----------------|
 *  |  小莹   |   vixyin      |
 *  |--------|----------------|
 *  |  小新   |   vixx        |
 *  |--------|----------------|
 *  |  楠楠   |   vinn        |
 *  |--------|----------------|
 *  |  老孙   |   vils        |
 *  |--------|----------------|
 */
  static Future<void> startSpeaking({
    String volume = '50',
    String speed = '50',
    String pitch = '50',
    String voiceName = 'xiaoyan',
    String streamType = "3",
    required String content,
  }) async {
    Map<String, dynamic> arguments = {
      'volume': volume,
      'speed': speed,
      'pitch': pitch,
      'voiceName': voiceName,
      'content': content,
      'streamType': streamType,
    };
    return await methodChannel.invokeMethod('start_speaking', arguments);
  }

  ///取消播放
  static Future<void> stopSpeaking() async {
    return await methodChannel.invokeMethod('stop_speaking');
  }

  ///暂停播放
  static Future<void> pauseSpeaking() async {
    return await methodChannel.invokeMethod('pause_speaking');
  }

  ///继续播放
  static Future<void> resumeSpeaking() async {
    return await methodChannel.invokeMethod('resume_speaking');
  }

  ///是否播放中
  static Future<bool> isSpeaking() async {
    return await methodChannel.invokeMethod('is_speaking') ?? false;
  }

  ///销毁语音合成器
  static Future<void> ttsDestroy() async {
    return await methodChannel.invokeMethod('tts_destroy');
  }

  ///销毁语音识别器
  static Future<void> iatDestroy() async {
    return await methodChannel.invokeMethod('iat_destroy');
  }
}
