import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:speech_xf_example/home_page.dart';

void main() {
  runApp(const MyApp());
  //设置沉浸式状态栏，颜色透明
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light, //白色图标
    systemNavigationBarColor: Colors.white,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      backgroundColor: const Color(0xFF3A3A3A),
      position: ToastPosition.center,
      radius: 8,
      textPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: const HomePage(),
          ),
        ),
      ),
    );
  }
}
