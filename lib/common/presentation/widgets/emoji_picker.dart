import 'package:echojar/app/theme/app_colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

class AppEmojiPicker extends StatelessWidget {
  const AppEmojiPicker({super.key});

  /// Call this to show emoji picker and get result
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: const AppEmojiPicker(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          Navigator.of(context).pop(emoji.emoji); // Return emoji to caller
        },
        onBackspacePressed: () {
          Navigator.of(context).pop(''); // Return empty string
        },
        config: Config(
          height: 256,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.20
                    : 1.0),
          ),
          viewOrderConfig: const ViewOrderConfig(
            top: EmojiPickerItem.categoryBar,
            middle: EmojiPickerItem.searchBar,
            bottom: EmojiPickerItem.emojiView,
          ),
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: const CategoryViewConfig(),
          bottomActionBarConfig: const BottomActionBarConfig(
            backgroundColor: Colors.white24,
            showSearchViewButton: true,
            buttonColor: Colors.white24,
            buttonIconColor: Colors.grey,
          ),
          searchViewConfig: const SearchViewConfig(),
        ),
      ),
    );
  }
}
