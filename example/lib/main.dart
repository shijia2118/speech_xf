import 'package:flutter/material.dart';

import 'package:speech_xf_example/speech_to_text_page/speech_2_text_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Speech2TextPage(),
    );
  }
}
