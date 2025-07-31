import 'package:echojar/app/database/src/storage/schemes/jar.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Memo {
  @Id()
  int id = 0;

  String title;
  String? color;
  String filePath;

  final jar = ToOne<Jar>();

  Memo({
    required this.title,
    required this.filePath,
    this.color,
  });
}
