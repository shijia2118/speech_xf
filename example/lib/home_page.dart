import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_xf_example/constants.dart';
import 'package:speech_xf_example/speech_to_text_page/speech_2_text_page.dart';
import 'package:speech_xf_example/text_to_speech_page/text_to_speech_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String platform = "Android";
    if (Platform.isIOS) platform = 'IOS';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '讯飞语音示例',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Text(
              '当前APPID为:$appId\n本示例为讯飞语音Flutter($platform)平台开发者提供语音听写和语音合成等代码样例，旨在让用户能够依据该示例快速开发出基于语音接口的应用程序。',
              style: const TextStyle(color: Colors.white),
            ),
            pushWidget(
              '立刻体验语音听写',
              padding: const EdgeInsets.symmetric(vertical: 10),
              onPressed: () => pushTo(const Speech2TextPage()),
            ),
            pushWidget(
              '立刻体验语音合成',
              padding: const EdgeInsets.symmetric(vertical: 10),
              onPressed: () => pushTo(const TextToSpeechPage()),
            ),
          ],
        ),
      ),
    );
  }

  /// 跳转按钮
  Widget pushWidget(
    String text, {
    required Function() onPressed,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 页面跳转
  void pushTo(Widget targetPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }
}
