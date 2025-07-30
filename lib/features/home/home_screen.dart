import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/empty_placeholder.dart';
import 'package:echojar/features/create-jar/presentation/widgets/unlock_jar_dialog.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final db = await AppDatabase.getInstance();
      if (mounted) {
        context.read<JarViewModel>().refresh(db);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final jarNotifier = context.watch<JarViewModel>();
    final jars = jarNotifier.jars;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'EchoJar',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => ArchiveRoute().push(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const Icon(Icons.archive, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      const Text(
                        'Archived',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '${jarNotifier.archivedJars.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (jars.isEmpty)
            const EmptyPlaceholder(message: 'No jars yet. Create a jar first'),
          if (jars.isNotEmpty)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: jars.length,
                itemBuilder: (context, index) {
                  final jar = jars[index];
                  return _JarCard(jar: jar, jarNotifier: jarNotifier);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _JarCard extends StatelessWidget {
  final Jar jar;
  final JarViewModel jarNotifier;

  const _JarCard({required this.jar, required this.jarNotifier});

  @override
  Widget build(BuildContext context) {
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
