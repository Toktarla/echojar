import 'package:echojar/common/utils/extensions/color_extension.dart';
import 'package:echojar/data/data.dart';
import 'package:flutter/material.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/services/audio_recorder_service.dart';
import 'package:echojar/app/database/src/storage/schemes/memo.dart';

class CreateMemoDialog extends StatefulWidget {
  final void Function(Memo) onMemoCreated;

  const CreateMemoDialog({super.key, required this.onMemoCreated});

  static Future<Memo?> show(
      BuildContext context, {
        required final void Function(Memo) onMemoCreated,
      }) {
    return showDialog<Memo>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: CreateMemoDialog(onMemoCreated: onMemoCreated),
      ),
    );
  }

  @override
  State<CreateMemoDialog> createState() => _CreateMemoDialogState();
}

class _CreateMemoDialogState extends State<CreateMemoDialog> {
  final _memoTitleController = TextEditingController();
  final _recorderService = AudioRecorderService();
  final ValueNotifier<String?> _warningMessage = ValueNotifier<String?>(null);

  bool _recordingComplete = false;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _recorderService.init();
  }

  Future<void> _toggleRecording() async {
    _warningMessage.value = null;

    if (!_recorderService.isRecording) {
      final granted = await _recorderService.init();
      if (!granted) {
        _warningMessage.value = 'Microphone permission is required.';
        return;
      }
      await _recorderService.startRecording();
      setState(() => _recordingComplete = true);
    } else {
      await _recorderService.stopRecording();
      setState(() => _recordingComplete = false);
    }

    setState(() {}); // Refresh UI
  }

  void _saveMemo() {
    final title = _memoTitleController.text.trim();
    if (title.isEmpty || _recorderService.recordedFilePath == null) {
      _warningMessage.value = 'Please enter a title and record a memo.';
      return;
    }

    final memo = Memo(
      title: title,
      filePath: _recorderService.recordedFilePath!,
      color: _selectedColor?.toHex(),
    );

    widget.onMemoCreated(memo);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _memoTitleController.dispose();
    _recorderService.dispose();
    _warningMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.8,
        maxWidth: size.width * 0.9,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Create Memo', style: textTheme.headlineSmall),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Title Field
                    TextField(
                      controller: _memoTitleController,
                      style: textTheme.bodyMedium,
                      decoration: InputDecoration(
                        labelText: 'Memo Title',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Color Picker
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Choose color', style: textTheme.titleMedium),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
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
                                    ? Border.all(color: AppColors.textPrimary, width: 2)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Record Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          _recorderService.isRecording
                              ? Icons.stop
                              : Icons.mic,
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
                    ),

                    const SizedBox(height: 12),

                    if (_recorderService.isRecording)
                      const Icon(Icons.fiber_manual_record, color: AppColors.error)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Warning Text
            ValueListenableBuilder<String?>(
              valueListenable: _warningMessage,
              builder: (_, message, __) => message != null
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  message,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveMemo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
