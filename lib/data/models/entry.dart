import 'package:isar/isar.dart';

part 'entry.g.dart';

@collection
class Entry {
  Id id = Isar.autoIncrement;

  @enumerated
  late EntryType type;

  bool isPinned = false;

  String? title;

  late String content;

  String? dreamFeelings;

  String? dreamAssociations; // For dreams

  int? dailyMood; // 1-5 scale, replacing simple emotionIntensity

  String? wakeUpMood; // For dreams

  List<String>? dreamTags; // For dreams

  String? therapyKeyLesson; // For therapy

  late DateTime timestamp;
}

enum EntryType { dream, insight, emotion, therapy }
