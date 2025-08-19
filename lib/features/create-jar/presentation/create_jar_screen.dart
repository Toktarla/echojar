import 'package:echojar/app/navigation/router.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/date_selector_bs.dart';
import 'package:echojar/common/presentation/widgets/emoji_picker.dart';
import 'package:echojar/common/presentation/widgets/error_dialog.dart';
import 'package:echojar/common/presentation/widgets/jar_theme_tile.dart';
import 'package:echojar/common/services/audio_recorder_service.dart';
import 'package:echojar/common/utils/extensions/color_extension.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:echojar/data/data.dart';
import 'package:echojar/features/create-jar/providers/jar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateJarScreen extends StatefulWidget {
  const CreateJarScreen({super.key});

  @override
  State<CreateJarScreen> createState() => _CreateJarScreenState();
}

class _CreateJarScreenState extends State<CreateJarScreen> {
  final _jarNameController = TextEditingController();
  final _memoNameController = TextEditingController();
  final _noteController = TextEditingController();

  int _selectedTheme = 0;
  bool _isSaving = false;
  bool _isLocked = false;
  String _selectedEmoji = '';
  DateTime? _scheduledAt;
  bool _recordingComplete = false;

  final AudioRecorderService _recorderService = AudioRecorderService();

  Color? _selectedColor;

  bool get isFormValid =>
      _jarNameController.text.trim().isNotEmpty ||
      _selectedEmoji != '' ||
      _scheduledAt != null || _recorderService.recordedFilePath != null;

  Future<void> _toggleRecording() async {
    if (!_recorderService.isRecording) {
      final granted = await _recorderService.init();
      if (!granted) {
        Toaster.showErrorToast(context, title: 'Microphone permission is required');
        return;
      }
      setState(() {
        _recordingComplete = false;
      });
      await _recorderService.startRecording();
    } else {
      await _recorderService.stopRecording();
      setState(() {
        _recordingComplete = true;
      });
    }

    setState(() {}); // Refresh UI
  }

  Future<void> _createJar() async {
    if (_jarNameController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final db = await AppDatabase.getInstance();
      final jarNotifier = context.read<JarViewModel>();

      final now = DateTime.now();
      final scheduledAt = _scheduledAt ?? now.add(const Duration(days: 14));

      final jar = Jar(
        name: _jarNameController.text.trim(),
        theme: themes[_selectedTheme],
        isLocked: _isLocked,
        createdAt: now,
        emoji: _selectedEmoji,
        note: _noteController.text.trim(),
        scheduledAt: scheduledAt,
      );

      jarNotifier.createJar(db, jar);

      if (_recorderService.recordedFilePath != null) {
        final memo = Memo(
          title: _memoNameController.text.trim(),
          filePath: _recorderService.recordedFilePath!,
          color: _selectedColor?.toHex(),
        );
        jarNotifier.addMemo(db, memo, jar);
      }

      if (mounted) context.goNamed('Home');
    } catch (e) {
      print(e);
      if (mounted) {
        ErrorDialog.show(context, 'Failed to create jar.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _jarNameController.dispose();
    _noteController.dispose();
    _memoNameController.dispose();
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Jar', style: Theme.of(context).textTheme.headlineLarge,)),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: 'Jar Details',
              children: [
                _buildLabeledField(
                  label: 'Jar Name',
                  child: TextField(
                    controller: _jarNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      focusColor: AppColors.primary,
                      focusedBorder: OutlineInputBorder(),
                      hintText: 'Enter a name for your jar',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabeledField(
                  label: 'Theme',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(themes.length, (i) {
                      return JarThemeTile(
                        themeName: themes[i],
                        isSelected: _selectedTheme == i,
                        onTap: () => setState(() => _selectedTheme = i),
                      );
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lock this Jar?',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Switch(
                      value: _isLocked,
                      onChanged: (val) => setState(() => _isLocked = val),
                    ),
                  ],
                ),
                _buildLabeledField(
                  label: 'Jar Icon',
                  subLabel:
                      'pick an emoji that reflects this memory or message',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final selectedEmoji =
                              await AppEmojiPicker.show(context);
                          if (selectedEmoji != null &&
                              selectedEmoji.isNotEmpty) {
                            setState(() {
                              _selectedEmoji = selectedEmoji;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                _selectedEmoji.isNotEmpty
                                    ? 'Selected Emoji'
                                    : 'Select Emoji',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(width: 8),
                            Text(_selectedEmoji,
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                          ],
                        ),
                      ),
                      if (_selectedEmoji.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _selectedEmoji = ''),
                        )
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabeledField(
                  label: 'Jar Scheduled Date',
                  subLabel:
                      'set a date when this jar will be unlocked. Think of it as a message to your future self — the jar will stay sealed until then',
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          _scheduledAt == null
                              ? 'Pick Date'
                              : '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: () {
                          DateSelectorBS.show(
                            context,
                            onDateSelected: (date) {
                              setState(() => _scheduledAt = date);
                            },
                          );
                        },
                      ),
                      if (_scheduledAt != null) ...[
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _scheduledAt = null),
                        )
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabeledField(
                  label: 'Note (Optional)',
                  child: TextField(
                    controller: _noteController,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      focusColor: AppColors.primary,
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      hintText: 'Add a note about this jar...',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              title: 'Memo Details',
              children: [
                _buildLabeledField(
                  label: 'Memo Title',
                  child: TextField(
                    controller: _memoNameController,
                    decoration: const InputDecoration(
                      labelText: 'Memo Name',
                      border: OutlineInputBorder(),
                      focusColor: AppColors.primary,
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabeledField(
                  label: 'Memo Color',
                  child: SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableColors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final color = availableColors[index];
                        final isSelected = _selectedColor == color;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabeledField(
                  label: 'Memo Record',
                  subLabel: 'write down a message for the future',
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(
                          _recorderService.isRecording ? Icons.stop : Icons.mic,
                          color: Colors.black,
                        ),
                        label: Text(
                          _recorderService.isRecording
                              ? 'Stop Recording'
                              : 'Record Memo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: _toggleRecording,
                      ),
                      const SizedBox(width: 12),
                      if (_recorderService.isRecording)
                        const Icon(Icons.fiber_manual_record,
                            color: AppColors.error)
                      else if (_recordingComplete)
                        const Icon(Icons.check_circle,
                            color: AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: !_isSaving || isFormValid ? _createJar : () => Toaster.showErrorToast(context, title: 'Fill all required fields'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isSaving && !isFormValid
                      ? Colors.grey.shade400
                      : AppColors.primaryLight,
                  foregroundColor: !_isSaving && !isFormValid
                      ? Colors.grey.shade800
                      : Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.grey.shade800,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('Create Jar',
                        style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabeledField(
      {required String label, String? subLabel, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: Theme.of(context).textTheme.bodyLarge,
            children: subLabel != null
                ? [
                    const TextSpan(text: '\t'), // line break
                    TextSpan(
                      text: '($subLabel)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
