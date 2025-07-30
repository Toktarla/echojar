import 'package:echojar/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HintCard extends StatelessWidget {
  const HintCard({
    required this.title,
    this.onNext,
    this.onFinish,
    this.isLast = false,
    super.key,
  });

  final String title;
  final VoidCallback? onNext;
  final VoidCallback? onFinish;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isLast)
                  TextButton(
                    onPressed: onFinish,
                    child: Text(
                      'Finish',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.primary),
                    ),
                  )
                else ...[
                  TextButton(
                    onPressed: onFinish,
                    child: Text(
                      'Skip',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                  TextButton(
                    onPressed: onNext,
                    child: Text(
                      'Next',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
