part of 'toaster.dart';

class _ToasterBody extends StatelessWidget {
  const _ToasterBody({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.hasImage,
  });
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool hasImage;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // if (hasImage) ...[
          //   Image.asset(
          //     Assets.images.icon1024x1024.path,
          //     width: 20,
          //     height: 20,
          //   ),
          //   const SizedBox(width: 8),
          // ],
          Flexible(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
