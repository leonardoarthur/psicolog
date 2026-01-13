import 'package:flutter/foundation.dart';
import '../../data/models/entry.dart';
import '../../data/services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Entry> _entries = [];

  JournalProvider(this._databaseService) {
    _init();
  }

  List<Entry> get entries => _entries;

  void _init() {
    _databaseService.watchEntries().listen((entries) {
      _entries = entries;
      notifyListeners();
    });
  }

  Future<void> addEntry(Entry entry) async {
    await _databaseService.addEntry(entry);
  }

  Map<DateTime, int> getEmotionalHeatmap() {
    final Map<DateTime, List<Entry>> entriesByDate = {};

    for (var entry in _entries) {
      final date = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );
      if (entriesByDate.containsKey(date)) {
        entriesByDate[date]!.add(entry);
      } else {
        entriesByDate[date] = [entry];
      }
    }

    final Map<DateTime, int> heatmap = {};

    entriesByDate.forEach((date, dayEntries) {
      bool hasDream = dayEntries.any((e) => e.type == EntryType.dream);
      bool hasEmotion = dayEntries.any((e) => e.type == EntryType.emotion);
      bool hasCriticalEmotion = dayEntries.any(
        (e) => e.type == EntryType.emotion && (e.emotionIntensity ?? 0) >= 4,
      );

      int level = 0;

      if (hasCriticalEmotion || (hasDream && hasEmotion)) {
        level = 4;
      } else if (hasEmotion) {
        level = 3;
      } else if (hasDream) {
        level = 2;
      } else {
        level = 1;
      }

      heatmap[date] = level;
    });

    return heatmap;
  }
}
