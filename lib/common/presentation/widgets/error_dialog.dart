import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? text;
  const ErrorDialog({super.key, this.text});

  static Future<void> show(BuildContext context, String text) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ErrorDialog(
        text: text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(text ?? 'Something went wrong'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('OK'))
      ],
    );
  }
}
