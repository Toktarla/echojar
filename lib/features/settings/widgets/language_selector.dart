import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const LanguageSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const languages = {'en': 'English', 'ru': 'Русский'};

    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Language", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: languages.entries.map((entry) {
                final isSelected = entry.key == selected;
                return GestureDetector(
                  onTap: () => onChanged(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryLight : Colors.grey,
                      ),
                    ),
                    child: Text(entry.value),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
