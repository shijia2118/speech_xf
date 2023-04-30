import 'package:flutter_test/flutter_test.dart';
import 'package:speech_xf/speech_xf.dart';
import 'package:speech_xf/speech_xf_platform_interface.dart';
import 'package:speech_xf/speech_xf_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSpeechXfPlatform
    with MockPlatformInterfaceMixin
    implements SpeechXfPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpeechXfPlatform initialPlatform = SpeechXfPlatform.instance;

  test('$MethodChannelSpeechXf is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpeechXf>());
  });

  test('getPlatformVersion', () async {
    SpeechXf speechXfPlugin = SpeechXf();
    MockSpeechXfPlatform fakePlatform = MockSpeechXfPlatform();
    SpeechXfPlatform.instance = fakePlatform;

    expect(await speechXfPlugin.getPlatformVersion(), '42');
  });
}
