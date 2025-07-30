import 'package:flutter/material.dart';
import 'package:echojar/app/theme/app_colors.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancel',
    this.confirmText = 'Delete',
  });

  static Future<bool?> show(
      BuildContext context, {
        required String title,
        required String content,
        String cancelText = 'Cancel',
        String confirmText = 'Delete',
      }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor ?? AppColors.surface,
      shape: Theme.of(context).dialogTheme.shape,
      titleTextStyle: Theme.of(context).dialogTheme.titleTextStyle,
      contentTextStyle: Theme.of(context).dialogTheme.contentTextStyle,
      title: Text(title),
      content: Text(content),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
