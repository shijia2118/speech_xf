import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'speech_xf_platform_interface.dart';

class MethodChannelSpeechXf extends SpeechXfPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('xf_speech_to_text');

  @override
  Future<void> init(String appId) async {
    await methodChannel.invokeMethod<void>('init', {'appId': appId});
  }

  @override
  Future<String?> openNativeUIDialog({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) async {
    String? result = await methodChannel.invokeMethod<String>(
      'open_native_ui_dialog',
      {
        'isDynamicCorrection': isDynamicCorrection,
        'language': language,
        'vadBos': vadBos,
        'vadEos': vadEos,
        'ptt': ptt,
      },
    );
    return result;
  }

  @override
  Future<String?> startListening({
    bool? isDynamicCorrection,
    String? language,
    String? vadBos,
    String? vadEos,
    String? ptt,
  }) async {
    String? result = await methodChannel.invokeMethod<String>(
      'start_listening',
      {
        'isDynamicCorrection': isDynamicCorrection,
        'language': language,
        'vadBos': vadBos,
        'vadEos': vadEos,
        'ptt': ptt,
      },
    );
    return result;
  }

  @override
  Future<void> stopListening() async {
    await methodChannel.invokeMethod<void>('stop_listening');
  }

  @override
  Future<void> cancelListening() async {
    await methodChannel.invokeMethod<void>('cancel_listening');
  }

  @override
  Future<void> uploadUserWords(String contents) async {
    await methodChannel.invokeMethod<void>(
      'upload_user_words',
      {'contents': contents},
    );
  }

  @override
  Future<String?> audioRecognizer(String path) async {
    return await methodChannel.invokeMethod<String>(
      'audio_recognizer',
      {'path': path},
    );
  }
}
