import 'dart:async';
import 'dart:io';

import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:echojar/app/theme/app_colors.dart';
import 'package:echojar/common/presentation/widgets/error_dialog.dart';
import 'package:echojar/common/utils/extensions/color_extension.dart';
import 'package:echojar/common/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

class PlayableMemoTile extends StatefulWidget {
  final Memo memo;

  const PlayableMemoTile({required this.memo});

  @override
  State<PlayableMemoTile> createState() => _PlayableMemoTileState();
}

class _PlayableMemoTileState extends State<PlayableMemoTile> {
  late final AudioPlayer _audioPlayer;
  late StreamSubscription<PlayerState> _playerStateSub;

  bool _isPlaying = false;
  bool _playedOnce = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      final isPlayingNow = state.playing;
      final completed = state.processingState == ProcessingState.completed;

      if (mounted) {
        setState(() {
          _isPlaying = isPlayingNow && !completed;
          _playedOnce = true;
        });
      }

      if (completed) {
        _audioPlayer.stop();
      }
    });
  }

  Future<void> _playOrStopMemo() async {
    try {
      final filePath = widget.memo.filePath;
      if (filePath.isEmpty) {
        ErrorDialog.show(context, 'No file path found for this memo.');
      }

      if (_isPlaying) {
        await _audioPlayer.stop();
        return;
      }

      await _audioPlayer.setFilePath(filePath);
      await _audioPlayer.play();
    } catch (e) {
      ErrorDialog.show(context, 'Failed to play audio.');
    }
  }

  Future<void> _shareMemoFile(BuildContext context, String title, String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      Toaster.showErrorToast(context, title: 'File not found');
      return;
    }

    try {
      SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: title,
          subject: 'Voice Memo: $title',
        ),
      );
    } catch (e) {
      Toaster.showErrorToast(context, title: 'Sharing failed');
    }
  }

  @override
  void dispose() {
    _playerStateSub.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.memo.color?.toColor() ?? AppColors.primaryLight;
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: IconButton(
          icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: _playOrStopMemo,
        ),
        title: Text(widget.memo.title == '' ? 'No Title' : widget.memo.title,
            style: Theme.of(context).textTheme.headlineMedium),
        trailing: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () async {
            await _shareMemoFile(context, widget.memo.title, widget.memo.filePath);
          },
        ),
      ),
    );
  }
}
