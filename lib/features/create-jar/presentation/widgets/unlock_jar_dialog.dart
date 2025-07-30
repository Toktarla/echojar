import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';
import 'package:provider/provider.dart';

class UnlockJarDialog extends StatefulWidget {
  final Jar jar;

  const UnlockJarDialog({super.key, required this.jar});

  static Future<void> show(BuildContext context, Jar jar) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UnlockJarDialog(jar: jar),
    );
  }

  @override
  State<UnlockJarDialog> createState() => _UnlockJarDialogState();
}

class _UnlockJarDialogState extends State<UnlockJarDialog> {
  final ValueNotifier<int> _tapCount = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isUnlocking = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _tapCount.dispose();
    _isUnlocking.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_isUnlocking.value) return;

    _tapCount.value += 1;

    if (_tapCount.value >= 10) {
      _isUnlocking.value = true;
      try {
        final db = await AppDatabase.getInstance();
        widget.jar.isLocked = false;

        final jarNotifier = context.read<JarViewModel>();
        jarNotifier.updateJar(db, widget.jar);
        if (context.mounted) {
          jarNotifier.refresh(db);
          Navigator.of(context).pop();
        }
      } catch (e) {
        debugPrint('Error unlocking jar: $e');
        if (context.mounted) {
          Toaster.showErrorToast(context, title: 'Failed to unlock jar');
        }
      } finally {
        _isUnlocking.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Unlock Jar',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, color: AppColors.primary,),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _tapCount,
            builder: (context, count, _) {
              final progress = count / 10.0;
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          color: AppColors.primary,
                        ),
                      ),
                      AnimatedScale(
                        scale: 1.0 + (progress * 0.2),
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          progress >= 1.0 ? Icons.lock_open_rounded : Icons.lock_rounded,
                          size: 40,
                          color: progress >= 1.0 ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Taps: $count / 10',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap below to unlock your memory jar',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _isUnlocking,
          builder: (context, loading, _) {
            return Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: loading ? null : _handleTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text('Tap to Unlock'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

