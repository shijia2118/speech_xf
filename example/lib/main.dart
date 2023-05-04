import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:speech_xf_example/speech_to_text_page/speech_2_text_page.dart';

void main() {
  runApp(const MyApp());
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
            child: const Speech2TextPage(),
          ),
        ),
      ),
    );
  }
}
