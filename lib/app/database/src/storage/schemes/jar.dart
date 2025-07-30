import 'package:echojar/app/database/src/storage/schemes/memo.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Jar {
  @Id()
  int id = 0;

  String name;
  String? note;
  String theme;
  String emoji;

  bool isLocked;
  bool isArchived;
  bool isNotificationEnabled;

  DateTime createdAt;
  DateTime scheduledAt;

  @Backlink('jar')
  final memos = ToMany<Memo>();

  Jar({
    required this.name,
    required this.theme,
    required this.emoji,
    this.note,
    this.isLocked = false,
    this.isNotificationEnabled = false,
    this.isArchived = false,
    required this.createdAt,
    required this.scheduledAt,
  });
}
