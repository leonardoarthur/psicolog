import 'package:isar/isar.dart';

part 'entry.g.dart';

@collection
class Entry {
  Id id = Isar.autoIncrement;

  @enumerated
  late EntryType type;

  String? title;

  late String content;

  String? dreamFeelings;

  String? dreamAssociations; // For dreams

  int? emotionIntensity; // 1-5, for emotions

  late DateTime timestamp;
}

enum EntryType { dream, insight, emotion }
