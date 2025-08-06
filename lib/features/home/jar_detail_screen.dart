import 'dart:async';

import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:echojar/common/presentation/widgets/empty_placeholder.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:echojar/features/home/widgets/playback_memo_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/features/create-jar/presentation/widgets/create_memo_dialog.dart';
import 'package:echojar/features/create-jar/presentation/widgets/update_jar_dialog.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:intl/intl.dart';
import '../../common/services/local_notification_service.dart';

class JarDetailScreen extends StatefulWidget {
  final Jar jar;

  const JarDetailScreen({super.key, required this.jar});

  @override
  State<JarDetailScreen> createState() => _JarDetailScreenState();
}

class _JarDetailScreenState extends State<JarDetailScreen> {
  late AppDatabase _db;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    _db = await AppDatabase.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final jarNotifier = context.watch<JarViewModel>();
    final isReadyToArchive = now.isAfter(widget.jar.scheduledAt) && !widget.jar.isArchived;

    return Scaffold(
      appBar: AppBar(
        title: Text('EchoJar', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.delete),
            tooltip: 'Delete Jar',
            onPressed: () {
              jarNotifier.deleteJar(_db, widget.jar.id);
              context.pop();
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            tooltip: 'Edit Jar',
            onPressed: () async {
              await UpdateJarDialog.show(context, initialJar: widget.jar,
                  onSubmit: (updatedJar) {
                jarNotifier.updateJar(_db, updatedJar);
                setState(() {
                  widget.jar.name = updatedJar.name;
                  widget.jar.scheduledAt = updatedJar.scheduledAt;
                  widget.jar.note = updatedJar.note;
                  widget.jar.emoji = updatedJar.emoji;
                  widget.jar.isLocked = updatedJar.isLocked;
                });
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.mic, color: AppColors.primary),
        backgroundColor: AppColors.primaryLight,
        label: Text("New Memo", style: Theme.of(context).textTheme.titleLarge),
        onPressed: () => CreateMemoDialog.show(
          context,
          onMemoCreated: (Memo memo) async {
            final db = await AppDatabase.getInstance();
            context.read<JarViewModel>().addMemo(db, memo, widget.jar);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          spacing: 24,
          children: [
            if (isReadyToArchive) _buildArchiveBanner(context),
            _buildJarHeader(context),
            _buildNotificationSection(context),
            _buildMemoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildJarHeader(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primaryLight,
      ),
      child: Row(
        children: [
          SizedBox(
            height: 135,
            width: 135,
            child: Image.asset(
              'assets/icon/jar_${widget.jar.theme.toLowerCase()}.png',
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        border: Border.all(color: AppColors.textSecondary, width: 2),
                      ),
                      child: Text(widget.jar.emoji,
                          style: const TextStyle(fontSize: 28)),
                    ),
                    Flexible(
                      child: Text(
                        widget.jar.name,
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${DateFormat('dd MMM yyyy').format(widget.jar.createdAt)} — ${DateFormat('dd MMM yyyy').format(widget.jar.scheduledAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                if (widget.jar.note != null && widget.jar.note != '') ...[
                  Text(
                    'Note: ${widget.jar.note}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Progress Notifications",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "You'll get reminders at 20%, 50%, 80%, and the final unlock time.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.jar.isNotificationEnabled,
            onChanged: (enabled) async {
              setState(() => widget.jar.isNotificationEnabled = enabled);

              final updatedJar = widget.jar;
              context.read<JarViewModel>().updateJar(_db, updatedJar);

              if (enabled) {
                await LocalNotificationService.scheduleProgressNotifications(
                  createdDate: updatedJar.createdAt,
                  scheduledDate: updatedJar.scheduledAt,
                  title: updatedJar.name,
                  context: context,
                );
                if (kDebugMode)
                  await LocalNotificationService.printPendingNotifications();
                Toaster.showSuccessToast(context,
                    title: 'Notifications scheduled');
              } else {
                await LocalNotificationService.cancelProgressNotifications(
                  updatedJar.createdAt,
                );
                if (kDebugMode)
                  await LocalNotificationService.printPendingNotifications();
                Toaster.showSuccessToast(context,
                    title: 'Notifications cancelled');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemoSection(BuildContext context) {
    final memos = context.watch<JarViewModel>().getMemosForJar(widget.jar.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              'Voice Memos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '(swipe to delete)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (memos.isEmpty)
          const EmptyPlaceholder(message: 'No memos yet')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: memos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final memo = memos[i];
              return Dismissible(
                behavior: HitTestBehavior.translucent,
                key: ValueKey(memo.id),
                background: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await DeleteConfirmationDialog.show(
                    context,
                    title: 'Delete Memo',
                    content: 'Are you sure you want to delete "${memo.title}"?',
                  );
                },
                onDismissed: (_) async {
                  context
                      .read<JarViewModel>()
                      .deleteMemo(_db, memo.id, widget.jar.id);
                  Toaster.showSuccessToast(context, title: 'Deleted');
                },
                child: PlayableMemoTile(memo: memo),
              );
            },
          ),
      ],
    );
  }

  Widget _buildArchiveBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jar Ready to Archive",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "The scheduled date has passed. You can now archive this jar to declutter your space.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              final jarViewModel = context.read<JarViewModel>();
              jarViewModel.archiveJar(_db, widget.jar);
              Toaster.showSuccessToast(context, title: 'Jar archived');
              context.pop(); // Go back after archiving
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }
}
