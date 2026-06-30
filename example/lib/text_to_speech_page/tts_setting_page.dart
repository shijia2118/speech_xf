import 'package:flutter/material.dart';
import 'package:speech_xf_example/constants.dart';
import 'package:speech_xf_example/utils/dialog_util.dart';

class TtsSettingPage extends StatefulWidget {
  final String volume;
  final String pitch;
  final String speed;
  final String streamType;
  final Function(Map<String, dynamic>?) callback;
  const TtsSettingPage({
    super.key,
    required this.callback,
    required this.pitch,
    required this.volume,
    required this.speed,
    required this.streamType,
  });

  @override
  State<TtsSettingPage> createState() => _TtsSettingPageState();
}

class _TtsSettingPageState extends State<TtsSettingPage> {
  List<Map<String, dynamic>> settingList = [
    {
      'title': '语速',
      'subTitle': "默认值:50",
    },
    {
      'title': '音调',
      'subTitle': "默认值:50",
    },
    {
      'title': '音量',
      'subTitle': "默认值:50",
    },
    {
      'title': '音频流类型',
    },
  ];

  late String speed;
  late String volume;
  late String pitch;
  late String streamType;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        final map = {
          'volume': volume,
          'speed': speed,
          'pitch': pitch,
          'streamType': streamType,
        };
        widget.callback(map);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
          leading: IconButton(
            onPressed: onBackHandler,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            String? subTitle = settingList[index]['subTitle'];

            return ListTile(
              title: Text(settingList[index]['title']),
              subtitle: subTitle == null ? null : Text(subTitle),
              trailing: const Icon(Icons.arrow_right_outlined),
              onTap: () => onClickHandle(settingList[index]['title']),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: settingList.length,
        ),
      ),
    );
  }

  /// 初始化参数
  void initParams() {
    // 语速
    speed = widget.speed;
    // 音调
    pitch = widget.pitch;
    // 音量
    volume = widget.volume;
    // 音频流类型
    streamType = widget.streamType;
  }

  /// 点击事件
  void onClickHandle(String title) {
    switch (title) {
      case '语速':
        inputDialog(title, speed);
        break;
      case '音调':
        inputDialog(title, pitch);
        break;
      case '音量':
        inputDialog(title, volume);
        break;
      case '音频流类型':
        selectStreamType();
        break;
      default:
        break;
    }
  }

  /// 音频流类型
  Future<void> selectStreamType() async {
    List<MapEntry<String, String>> options = kStreamTypes
        .map((e) => MapEntry(kStreamTypes.indexOf(e).toString(), e))
        .toList();
    String? result = await showOptionDialog(
      context: context,
      title: '请选择音频流类型',
      options: options,
    );
    if (result != null) {
      streamType = result;
    }
  }

  ///设置语速、音量和音调
  void inputDialog(String title, String initText) async {
    String? result = await showValueInputDialog(
      context: context,
      title: title,
      hintText: '请输入0~100的整数值',
      initialText: initText,
      validator: (value) {
        if (value == null) {
          return '请输入0~100的整数值';
        }
        int? v = int.tryParse(value);
        if (v == null) {
          return '请输入0~100的整数值';
        }
        if (v < 0 || v > 100) {
          return '请输入0~100的整数值';
        }
        return null;
      },
    );
    if (result != null) {
      if (title.contains('音量')) {
        volume = result;
      } else if (title.contains('语速')) {
        speed = result;
      } else if (title.contains('音调')) {
        pitch = result;
      }
    }
  }

  /// 返回按钮
  void onBackHandler() {
    Map<String, dynamic> map = {
      'volume': volume,
      'speed': speed,
      'pitch': pitch,
      'streamType': streamType,
    };
    widget.callback(map);
    Navigator.pop(context);
  }
}
