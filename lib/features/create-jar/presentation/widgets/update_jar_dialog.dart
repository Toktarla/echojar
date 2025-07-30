import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/emoji_picker.dart';
import 'package:echojar/data/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateJarDialog extends StatefulWidget {
  final Jar initialJar;
  final void Function(Jar) onSubmit;

  const UpdateJarDialog({super.key, required this.initialJar, required this.onSubmit});

  static Future<Jar?> show(BuildContext context,
      {required Jar initialJar, required void Function(Jar) onSubmit}) {
    return showModalBottomSheet<Jar>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: UpdateJarDialog(initialJar: initialJar, onSubmit: onSubmit),
      ),
    );
  }

  @override
  State<UpdateJarDialog> createState() => _UpdateJarDialogState();
}

class _UpdateJarDialogState extends State<UpdateJarDialog> {
  late final TextEditingController nameController;
  late final TextEditingController noteController;

  late int _selectedThemeIndex;
  late String _selectedEmoji;
  late bool isLocked;
  late bool isArchived;
  DateTime? scheduledDate;

  @override
  void initState() {
    super.initState();
    final jar = widget.initialJar;
    nameController = TextEditingController(text: jar.name);
    noteController = TextEditingController(text: jar.note);
    _selectedThemeIndex = themes.indexOf(jar.theme);
    _selectedThemeIndex = _selectedThemeIndex == -1 ? 0 : _selectedThemeIndex;
    _selectedEmoji = jar.emoji;
    isLocked = jar.isLocked;
    isArchived = jar.isArchived;
    scheduledDate = jar.scheduledAt;
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final updatedJar = Jar(
      name: nameController.text.trim(),
      theme: themes[_selectedThemeIndex],
      emoji: _selectedEmoji,
      note: noteController.text.trim(),
      isLocked: isLocked,
      isArchived: isArchived,
      createdAt: widget.initialJar.createdAt,
      scheduledAt: scheduledDate ?? widget.initialJar.scheduledAt,
    )..id = widget.initialJar.id;

    widget.onSubmit(updatedJar);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Update Jar', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Name', Icons.label),
            const SizedBox(height: 12),
            _buildLabeledField(
              label: 'Theme',
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children: List.generate(themes.length, (i) {
                  return ChoiceChip(
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.primaryLight,
                    label: Text(themes[i], style: theme.textTheme.titleMedium),
                    selected: _selectedThemeIndex == i,
                    onSelected: (_) => setState(() => _selectedThemeIndex = i),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            _buildLabeledField(
              label: 'Emoji',
              child: InkWell(
                onTap: () async {
                  final selected = await AppEmojiPicker.show(context);
                  if (selected != null && selected.isNotEmpty) {
                    setState(() => _selectedEmoji = selected);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedEmoji.isNotEmpty ? _selectedEmoji : 'Select an emoji',
                        style: textTheme.titleMedium,
                      ),
                      const Spacer(),
                      const Icon(Icons.emoji_emotions_outlined, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(noteController, 'Note', Icons.note, maxLines: 2),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Locked'),
              value: isLocked,
              onChanged: (value) => setState(() => isLocked = value),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Archived'),
              value: isArchived,
              onChanged: (value) => setState(() => isArchived = value),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Scheduled Date'),
              subtitle: Text(
                scheduledDate != null
                    ? DateFormat.yMMMMd().format(scheduledDate!)
                    : 'No date selected',
                style: textTheme.bodyMedium,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  initialDate: scheduledDate ?? DateTime.now(),
                );
                if (picked != null) {
                  setState(() => scheduledDate = picked);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Update', style: textTheme.titleLarge),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
