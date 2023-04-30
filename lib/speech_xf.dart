
import 'speech_xf_platform_interface.dart';

class SpeechXf {
  Future<String?> getPlatformVersion() {
    return SpeechXfPlatform.instance.getPlatformVersion();
  }
}
