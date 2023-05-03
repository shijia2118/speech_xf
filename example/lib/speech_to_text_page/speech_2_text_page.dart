import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    speechController.dispose();
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
          ],
        ),
      ),
    );
  }

  /// 初始化SDK
  void initSdk() async {
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
        String? text = await SpeechXf.openNativeUIDialog(
          isDynamicCorrection: true,
          language: settingResult['language'],
          vadBos: settingResult['vadBos'],
          vadEos: settingResult['vadEos'],
          ptt: settingResult['ptt'],
        );
        if (text != null && text.isNotEmpty) {
          speechController.clear();
          speechController.text = text;
        }
      },
    );
  }

  /// 开始无UI语音识别
  void startListening() async {
    PermissionUtil.microPhone(
      context,
      action: () async {
        String? text = await SpeechXf.startListening(
          isDynamicCorrection: true,
          language: settingResult['language'],
          vadBos: settingResult['vadBos'],
          vadEos: settingResult['vadEos'],
          ptt: settingResult['ptt'],
        );
        if (text != null && text.isNotEmpty) {
          speechController.clear();
          speechController.text = text;
        }
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
}
