import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech_xf_platform_interface.dart';

/// An implementation of [SpeechXfPlatform] that uses method channels.
class MethodChannelSpeechXf extends SpeechXfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('speech_xf');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
