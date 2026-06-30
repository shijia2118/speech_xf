import 'package:flutter/material.dart';

Future<String?> showOptionDialog({
  required BuildContext context,
  required String title,
  required List<MapEntry<String, String>> options,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: options
            .map(
              (option) => SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(option.key),
                child: Text(option.value),
              ),
            )
            .toList(),
      );
    },
  );
}

Future<String?> showValueInputDialog({
  required BuildContext context,
  required String title,
  required String hintText,
  String? initialText,
  required String? Function(String?) validator,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: initialText);
  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: hintText),
            validator: validator,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('确定'),
          ),
        ],
      );
    },
  );
  controller.dispose();
  return result;
}
