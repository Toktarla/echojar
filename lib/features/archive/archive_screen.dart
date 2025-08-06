import 'package:echojar/features/home/widgets/jar_card.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:echojar/common/presentation/widgets/empty_placeholder.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jarNotifier = context.watch<JarViewModel>();
    final archivedJars = jarNotifier.archivedJars;

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
            return JarCard(jar: jar, jarNotifier: jarNotifier);
          },
        ),
      ),
    );
  }
}
