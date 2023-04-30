import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speech_xf_method_channel.dart';

abstract class SpeechXfPlatform extends PlatformInterface {
  /// Constructs a SpeechXfPlatform.
  SpeechXfPlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeechXfPlatform _instance = MethodChannelSpeechXf();

  /// The default instance of [SpeechXfPlatform] to use.
  ///
  /// Defaults to [MethodChannelSpeechXf].
  static SpeechXfPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpeechXfPlatform] when
  /// they register themselves.
  static set instance(SpeechXfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
