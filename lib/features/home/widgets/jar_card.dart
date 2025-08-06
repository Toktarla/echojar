import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/features/create-jar/presentation/widgets/unlock_jar_dialog.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:flutter/material.dart';

class JarCard extends StatelessWidget {
  final Jar jar;
  final JarViewModel jarNotifier;

  const JarCard({required this.jar, required this.jarNotifier});

  @override
  Widget build(BuildContext context) {
    double progress = jarNotifier.getProgressForJar(jar);
    int percentage = (progress * 100).round();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (jar.isLocked) {
            UnlockJarDialog.show(context, jar);
          } else {
            JarDetailRoute($extra: jar).push(context);
          }
        },
        child: Stack(
          children: [
            Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/icon/jar_${jar.theme.toLowerCase()}.png',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              child: Column(
                children: [
                  Text(jar.emoji, style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      jar.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 20,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: Icon(
                jar.isLocked ? Icons.lock : Icons.lock_open,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}