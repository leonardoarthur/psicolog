import 'package:isar/isar.dart';

part 'daily_mood.g.dart';

@collection
class DailyMood {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  // 1: Muito Triste, 2: Triste, 3: Neutro, 4: Feliz, 5: Muito Feliz
  late int mood;
}
