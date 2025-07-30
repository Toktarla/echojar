import 'package:flutter/material.dart';
import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:echojar/app/database/src/storage/app_database.dart';

class JarViewModel extends ChangeNotifier {
  final Map<int, List<Memo>> _memosByJar = {};
  List<Jar> _allJars = [];

  // ✅ Only return unarchived jars for UI
  List<Jar> get jars => _allJars.where((jar) => !jar.isArchived).toList();

  // ✅ Return only archived jars
  List<Jar> get archivedJars => _allJars.where((jar) => jar.isArchived).toList();

  List<Memo> getMemosForJar(int jarId) => _memosByJar[jarId] ?? [];

  void refresh(AppDatabase db) {
    _allJars = db.getAllJars(); // include all jars
    _refreshAllMemos(db);
    notifyListeners();
  }

  void _refreshAllMemos(AppDatabase db) {
    _memosByJar.clear();
    for (var jar in _allJars) {
      _memosByJar[jar.id] = db.getMemosForJar(jar.id);
    }
  }

  void refreshJarMemos(AppDatabase db, int jarId) {
    _memosByJar[jarId] = db.getMemosForJar(jarId);
    notifyListeners();
  }

  void updateJar(AppDatabase db, Jar jar) {
    db.updateJar(jar);
    refresh(db);
  }

  void deleteJar(AppDatabase db, int id) {
    db.deleteJar(id);
    refresh(db);
  }

  void createJar(AppDatabase db, Jar jar) {
    db.addJar(jar);
    refresh(db);
  }

  void addMemo(AppDatabase db, Memo memo, Jar jar) {
    db.addMemo(memo, jar);
    refreshJarMemos(db, jar.id);
  }

  void deleteMemo(AppDatabase db, int memoId, int jarId) {
    db.deleteMemo(memoId);
    refreshJarMemos(db, jarId);
  }

  void updateMemo(AppDatabase db, Memo memo) {
    db.updateMemo(memo);
    refreshJarMemos(db, memo.jar.target?.id ?? -1);
  }

  double getProgressForJar(Jar jar) {
    final now = DateTime.now();
    double totalProgress = 0.0;

    final createdAt = jar.createdAt;
    final scheduledAt = jar.scheduledAt;

    if (scheduledAt.isBefore(createdAt)) {
      totalProgress += 1.0;
    } else {
      final totalDuration = scheduledAt.difference(createdAt).inSeconds;
      final elapsed = now.difference(createdAt).inSeconds;
      final progress = (elapsed / totalDuration).clamp(0.0, 1.0);
      totalProgress += progress;
    }

    return totalProgress;
  }

  // ✅ Archive a jar
  void archiveJar(AppDatabase db, Jar jar) {
    jar.isArchived = true;
    updateJar(db, jar);
  }

  // ✅ Unarchive a jar
  void unarchiveJar(AppDatabase db, Jar jar) {
    jar.isArchived = false;
    updateJar(db, jar);
  }
}
