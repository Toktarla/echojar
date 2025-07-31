import 'package:echojar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class JarThemeTile extends StatelessWidget {
  final String themeName;
  final bool isSelected;
  final VoidCallback onTap;

  const JarThemeTile({
    super.key,
    required this.themeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lowerCaseName = themeName.toLowerCase();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/jar_$lowerCaseName.png',
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              themeName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
