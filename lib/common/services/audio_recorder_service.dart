import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;

  bool get isRecording => _isRecording;
  String? get recordedFilePath => _filePath;

  Future<bool> init() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return false;

    if (!_recorder.isRecording && !_recorder.isPaused) {
      await _recorder.openRecorder();
    }
    return true;
  }

  Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/memo_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacMP4,
      bitRate: 96000,
      sampleRate: 44100,
    );
    _isRecording = true;
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    _isRecording = false;
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
