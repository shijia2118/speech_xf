import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:speech_xf/speech_xf.dart';

import '../utils/permission_util.dart';
import 'setting_page.dart';

class Speech2TextPage extends StatefulWidget {
  const Speech2TextPage({super.key});

  @override
  State<Speech2TextPage> createState() => _Speech2TextPageState();
}

class _Speech2TextPageState extends State<Speech2TextPage> {
  TextEditingController speechController = TextEditingController(); //语音识别结果控制器
  TextEditingController userWordsController = TextEditingController(); //语音识别结果控制器

  String? nativeUiText;
  Map<String, dynamic> settingResult = {
    'language': 'zh_cn',
    'vadBos': '5000',
    'vadEos': '1800',
    'ptt': '1',
  };

  @override
  void initState() {
    super.initState();
    initSdk();

    /// 语音听写结果监听
    SpeechXf().onResult().listen((event) {
      if (event.error != null) {
        showToast(event.error!, position: ToastPosition.bottom);
      } else {
        if (event.result != null) {
          speechController.text = speechController.text + event.result!;
        }
        if (event.isLast == true) {
          showToast('结束说话...', position: ToastPosition.bottom);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechController.dispose();
    userWordsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('讯飞听写示例'),
        actions: [
          IconButton(
            onPressed: push2Setting,
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            TextField(
              controller: speechController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '听写结果显示',
              ),
            ),
            OutlinedButton(
              onPressed: openNativeUIDialog,
              child: const Text('使用自带UI语音识别'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: startListening,
                  child: const Text('开始'),
                ),
                OutlinedButton(
                  onPressed: stopListening,
                  child: const Text('停止'),
                ),
                OutlinedButton(
                  onPressed: cancelListening,
                  child: const Text('取消'),
                ),
              ],
            ),
            const Text('使用无UI语音识别'),
            const SizedBox(height: 30),
            TextField(
              controller: userWordsController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '用户热词',
              ),
            ),
            const Text('上传词表,可以使云端识别更加准确,但仅对当前设备有效。如果要对所有设备生效，需要前往“讯飞开放平台官网—控制台 —个性化热词设置”。'),
            OutlinedButton(
              onPressed: uploadUserWords,
              child: const Text('上传用户热词'),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: audioRecognizer,
              child: const Text('音频流识别'),
            ),
          ],
        ),
      ),
    );
  }

  /// 初始化SDK
  void initSdk() async {
    // await SpeechXf.init('这里是你在讯飞平台申请的appid');
    await SpeechXf.init('e47801bc');
  }

  /// 跳转到设置页面
  void push2Setting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(
          settingResult: settingResult,
          callback: (map) {
            if (map != null) {
              settingResult = map;
            }
          },
        ),
      ),
    );
  }

  /// 自带ui语音识别
  void openNativeUIDialog() async {
    PermissionUtil.microPhone(
      context,
      action: () async {
        speechController.clear();
        showToast('请开始说话...', position: ToastPosition.bottom);
        await SpeechXf.openNativeUIDialog(
          isDynamicCorrection: true,
          language: settingResult['language'],
          vadBos: settingResult['vadBos'],
          vadEos: settingResult['vadEos'],
          ptt: settingResult['ptt'],
        );
      },
    );
  }

  /// 开始无UI语音识别
  void startListening() async {
    PermissionUtil.microPhone(
      context,
      action: () async {
        showToast('请开始说话...', position: ToastPosition.bottom);
        speechController.clear();
        await SpeechXf.startListening(
          isDynamicCorrection: false,
          language: settingResult['language'],
          vadBos: settingResult['vadBos'],
          vadEos: settingResult['vadEos'],
          ptt: settingResult['ptt'],
        );
      },
    );
  }

  /// 停止听写
  void stopListening() async {
    await SpeechXf.stopListening();
  }

  /// 取消听写
  void cancelListening() async {
    await SpeechXf.cancelListening();
  }

  /// 上传用户热词
  void uploadUserWords() async {
    String userWords = await rootBundle.loadString('assets/userwords');
    if (userWords.isNotEmpty) {
      userWordsController.text = userWords;
      await SpeechXf.uploadUserWords(userWords);
    }
  }

  /// 音频流识别
  void audioRecognizer() {
    PermissionUtil.storage(
      context,
      action: () async {
        speechController.clear();
        await SpeechXf.audioRecognizer('iattest.wav');
      },
    );
  }
}
