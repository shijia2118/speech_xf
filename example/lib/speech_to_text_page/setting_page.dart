import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:speech_xf_example/constants.dart';

class SettingPage extends StatefulWidget {
  final Map<String, dynamic> settingResult;
  final Function(Map<String, dynamic>?) callback;
  const SettingPage({
    super.key,
    required this.settingResult,
    required this.callback,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Map<String, dynamic>> settingList = [
    {
      'title': '语言设置',
      'subTitle': "选择要使用的语言区域,目前Android SDK支持中文、英文、日语、韩语、俄语、法语和西班牙语。",
    },
    {
      'title': '前端点检测',
      'subTitle': "开始录入音频后，音频前面部分最长静音时长，取值范围[0,10000ms],默认值5000ms。",
    },
    {
      'title': '后端点检测',
      'subTitle': "开始录入音频后，音频后面部分最长静音时长，取值范围[0,10000ms],默认值1800ms。",
    },
    {
      'title': '标点符号',
      'subTitle': "(仅中文支持)返回结果是否包含标点符号。",
    },
  ];

  late Map<String, dynamic> settingResult;
  String? language;
  String? initVadBos;
  String? initVadEos;
  String? ptt;

  @override
  void initState() {
    super.initState();
    initParams();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            return ListTile(
              title: Text(settingList[index]['title']),
              subtitle: Text(settingList[index]['subTitle']),
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
      onWillPop: () async {
        widget.callback(settingResult);
        return true;
      },
    );
  }

  /// 初始化参数
  void initParams() {
    settingResult = widget.settingResult;
    // 语言
    language = settingResult['language'];
    // 前端点超时
    initVadBos = settingResult['vadBos'];
    // 后端点超时
    initVadEos = settingResult['vadEos'];
    // 标点符号
    ptt = settingResult['ptt'];
  }

  /// 点击事件
  void onClickHandle(String title) async {
    switch (title) {
      case '语言设置':
        languageSetting(title);
        break;
      case '前端点检测':
        vadSetting(0);
        break;
      case '后端点检测':
        vadSetting(1);
        break;
      case '标点符号':
        pttSetting();
        break;
      case '数字结果':
        break;
      default:
        break;
    }
  }

  /// 语言设置
  void languageSetting(String title) {
    List<AlertDialogAction<String>> actions = kLanguages
        .map((e) => AlertDialogAction(key: e.values.first, label: e.values.first))
        .toList();
    Future.microtask(() async {
      String? result = await showConfirmationDialog<String>(
        context: context,
        title: title,
        actions: actions,
        initialSelectedActionKey: LanguageValue.of(language),
      );
      if (result != null) {
        settingResult['language'] = LanguageKey.of(result);
      }
      return result;
    });
  }

  /// 前后端点检测
  /// vadIndex:0-前端点 1-后端点
  void vadSetting(int vadIndex) {
    String? initialText;
    if (vadIndex == 0) {
      initialText = initVadBos;
    } else if (vadIndex == 1) {
      initialText = initVadEos;
    }
    Future.microtask(
      () async {
        List<String>? result = await showTextInputDialog(
          context: context,
          title: '提示',
          textFields: <DialogTextField>[
            DialogTextField(
              hintText: '请输入[0,10000]区间内的数字',
              initialText: initialText,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  int? valueInt = int.tryParse(value);
                  if (valueInt != null) {
                    if (valueInt < 0 || valueInt > 10000) {
                      return '请输入[0,10000]区间内的数字';
                    }
                  } else {
                    return '请输入超时时间';
                  }
                } else {
                  return '请输入超时时间';
                }
                return null;
              },
            ),
          ],
        );
        if (result != null && result.isNotEmpty) {
          if (vadIndex == 0) {
            settingResult['vadBos'] = result.first;
            initVadBos = result.first;
          } else if (vadIndex == 1) {
            settingResult['vadEos'] = result.first;
            initVadEos = result.first;
          }
        }
        return result;
      },
    );
  }

  /// 标点符号
  void pttSetting() {
    List<String> list = ['有', '无'];
    List<AlertDialogAction<String>> actions =
        list.map((e) => AlertDialogAction(key: e, label: e)).toList();
    Future.microtask(() async {
      String? result = await showConfirmationDialog<String>(
        context: context,
        title: '标点符号',
        actions: actions,
        initialSelectedActionKey: GetPttValue.of(ptt),
      );
      if (result != null) {
        settingResult['ptt'] = GetPttKey.of(result);
      }
      return result;
    });
  }

  /// 返回按钮
  void onBackHandler() {
    widget.callback(settingResult);
    Navigator.pop(context);
  }
}
