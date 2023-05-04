import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speech_xf_method_channel.dart';

abstract class SpeechXfPlatform extends PlatformInterface {
  SpeechXfPlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeechXfPlatform _instance = MethodChannelSpeechXf();

  static SpeechXfPlatform get instance => _instance;

  static set instance(SpeechXfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future init(String appId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<String?> openNativeUIDialog({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) {
    throw UnimplementedError('openNativeUIDialog() has not been implemented.');
  }

  Future<String?> startListening({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) {
    throw UnimplementedError('startListening() has not been implemented.');
  }

  Future<void> stopListening() {
    throw UnimplementedError('stopListening() has not been implemented.');
  }

  Future<void> cancelListening() {
    throw UnimplementedError('cancelListening() has not been implemented.');
  }

  Future<void> uploadUserWords(String contents) {
    throw UnimplementedError('uploadUserWords() has not been implemented.');
  }

  Future<String?> audioRecognizer(String path) {
    throw UnimplementedError('audioRecognizer() has not been implemented.');
  }
}
