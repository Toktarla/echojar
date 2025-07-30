import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:echojar/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class AppDatabase {
  static AppDatabase? _instance;
  static Future<AppDatabase> getInstance() async {
    if (_instance == null) {
      _instance = await _init();
    }
    return _instance!;
  }

  late final Store _store;
  late final Box<Jar> _jarBox;
  late final Box<Memo> _memoBox;

  AppDatabase._(this._store) {
    _jarBox = _store.box<Jar>();
    _memoBox = _store.box<Memo>();
  }

  static Future<AppDatabase> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(dir.path, "echojar"));
    return AppDatabase._(store);
  }

  // ==== CRUD for Jar ====
  int addJar(Jar jar) => _jarBox.put(jar);
  List<Jar> getAllJars() => _jarBox.getAll();
  Jar? getJar(int id) => _jarBox.get(id);
  void deleteJar(int id) => _jarBox.remove(id);
  void updateJar(Jar jar) => _jarBox.put(jar, mode: PutMode.update);

  // ==== CRUD for Memo ====
  int addMemo(Memo memo, Jar jar) {
    memo.jar.target = jar;
    return _memoBox.put(memo);
  }
  List<Memo> getAllMemos() => _memoBox.getAll();
  Memo? getMemo(int id) => _memoBox.get(id);
  void deleteMemo(int id) => _memoBox.remove(id);
  void updateMemo(Memo memo) => _memoBox.put(memo, mode: PutMode.update);

  List<Memo> getMemosForJar(int jarId) {
    final jar = _jarBox.get(jarId);
    return jar?.memos ?? [];
  }

  void dispose() {
    _store.close();
    _instance = null;
  }
}
