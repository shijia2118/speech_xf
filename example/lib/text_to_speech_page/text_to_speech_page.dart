import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:speech_xf/speech_xf.dart';
import 'package:speech_xf_example/constants.dart';
import 'package:speech_xf_example/text_to_speech_page/tts_setting_page.dart';

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  TextEditingController textEditingController = TextEditingController();

  String volume = "50";
  String speed = "50";
  String pitch = "50";
  String streamType = '3';
  String voicer = 'xiaoyan';

  @override
  void initState() {
    super.initState();
    initSdk();
    textEditingController.text = kSpeechSynthesisDefaultText;

    /// 循环播放
    SpeechXf.onLoopSpeakingListener(
      onCompeleted: (onCompeleted) async {
        await startSpeaking();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    SpeechXf.ttsDestroy();
  }

  @override
  Widget build(BuildContext context) {
    Widget right = IconButton(
      onPressed: push2Setting,
      icon: const Icon(Icons.settings),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('语音合成示例'), actions: [right]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              maxLines: 10,
            ),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (res) {},
                ),
                const Text('在线合成'),
                const Spacer(),
                FilledButton(onPressed: onSelectVoicer, child: const Text('发音人')),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                actionBtn('开始合成', onPressed: startSpeaking),
                actionBtn('取消', onPressed: stopSpeaking),
                actionBtn('暂停播放', onPressed: pauseSpeaking),
                actionBtn('继续播放', onPressed: resumeSpeaking),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 初始化SDK
  void initSdk() async {
    await SpeechXf.init(appId);
  }

  /// 跳转到设置页面
  void push2Setting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TtsSettingPage(
          speed: speed,
          volume: volume,
          pitch: pitch,
          streamType: streamType,
          callback: (map) {
            if (map != null) {
              speed = map['speed'];
              volume = map['volume'];
              pitch = map['pitch'];
              streamType = map['streamType'];
            }
          },
        ),
      ),
    );
  }

  ///选择发音人
  void onSelectVoicer() {
    List<AlertDialogAction<String>> actions = [];
    kVoicerList.forEach((key, value) {
      actions.add(AlertDialogAction(key: key, label: value));
    });
    Future.microtask(() async {
      String? result = await showConfirmationDialog<String>(
        context: context,
        title: '在线合成发音人选项',
        actions: actions,
        initialSelectedActionKey: voicer,
      );
      if (result != null) {
        voicer = result;
      }
      return result;
    });
  }

  /// 底部操作按钮
  Widget actionBtn(
    String text, {
    required Function() onPressed,
  }) {
    return FilledButton(onPressed: onPressed, child: Text(text));
  }

  /// 开始合成
  Future<void> startSpeaking() async {
    await SpeechXf.startSpeaking(
      content: textEditingController.text,
      speed: speed,
      volume: volume,
      pitch: pitch,
      voiceName: voicer,
      streamType: streamType,
    );
  }

  /// 取消合成
  void stopSpeaking() async {
    await SpeechXf.stopSpeaking();
  }

  /// 暂停合成
  void pauseSpeaking() async {
    await SpeechXf.pauseSpeaking();
  }

  /// 继续合成
  void resumeSpeaking() async {
    await SpeechXf.resumeSpeaking();
  }
}
