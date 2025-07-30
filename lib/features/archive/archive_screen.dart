import 'package:echojar/app/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:echojar/common/presentation/widgets/empty_placeholder.dart';
import 'package:echojar/features/create-jar/presentation/widgets/unlock_jar_dialog.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final archivedJars = context.watch<JarViewModel>().archivedJars;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Jars'),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: archivedJars.isEmpty
          ? const EmptyPlaceholder(message: 'No archived jars yet.')
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: archivedJars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final jar = archivedJars[index];
            return _JarCard(jar: jar);
          },
        ),
      ),
    );
  }
}

class _JarCard extends StatelessWidget {
  final Jar jar;

  const _JarCard({required this.jar});

  @override
  Widget build(BuildContext context) {
    final jarNotifier = context.read<JarViewModel>();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (jar.isLocked) {
            UnlockJarDialog.show(context, jar);
          } else {
            JarDetailRoute($extra: jar).push(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(jar.emoji, style: const TextStyle(fontSize: 40)),
              Text(
                jar.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: jarNotifier.getProgressForJar(jar),
                minHeight: 8,
                backgroundColor: AppColors.border,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Icon(
                jar.isLocked ? Icons.lock : Icons.lock_open,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
