import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class EnglishToChinesePage extends StatefulWidget {
  const EnglishToChinesePage({super.key});

  @override
  State<EnglishToChinesePage> createState() => _EnglishToChinesePageState();
}

class _EnglishToChinesePageState extends State<EnglishToChinesePage> {
  final TextEditingController recognizedTextController =
      TextEditingController();
  final TextEditingController translatedTextController =
      TextEditingController();

  bool isTranslating = false;

  @override
  void dispose() {
    recognizedTextController.dispose();
    translatedTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('英文实时转中文')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusPanel(isTranslating: isTranslating),
              const SizedBox(height: 16),
              _ResultInput(
                title: '英文识别结果',
                hintText: '等待识别对方说出的英文...',
                controller: recognizedTextController,
              ),
              const SizedBox(height: 16),
              _ResultInput(
                title: '中文翻译结果',
                hintText: '等待实时翻译结果...',
                controller: translatedTextController,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: isTranslating ? null : startTranslation,
                      icon: const Icon(Icons.mic),
                      label: const Text('开始翻译'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isTranslating ? stopTranslation : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('停止'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: clearResult,
                icon: const Icon(Icons.delete_outline),
                label: const Text('清空结果'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTranslation() {
    setState(() {
      isTranslating = true;
    });
    showToast('英文实时转中文方法待集成');
  }

  void stopTranslation() {
    setState(() {
      isTranslating = false;
    });
    showToast('停止翻译方法待集成');
  }

  void clearResult() {
    recognizedTextController.clear();
    translatedTextController.clear();
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.isTranslating});

  final bool isTranslating;

  @override
  Widget build(BuildContext context) {
    final Color color = isTranslating ? Colors.green : Colors.grey;
    final String text = isTranslating ? '正在监听英文' : '等待开始';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.translate, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '实时翻译状态',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultInput extends StatelessWidget {
  const _ResultInput({
    required this.title,
    required this.hintText,
    required this.controller,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          minLines: 5,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
