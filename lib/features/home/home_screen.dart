import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/empty_placeholder.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:echojar/features/home/widgets/jar_card.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';
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
                  return JarCard(jar: jar, jarNotifier: jarNotifier);
                },
              ),
            ),
        ],
      ),
    );
  }
}
