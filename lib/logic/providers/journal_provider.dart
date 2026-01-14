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
      // Logic for new Heatmap:
      // Level 1: Just Insight
      // Level 2: Dream recorded
      // Level 3: Mood registered (average mood > 0)
      // Level 4: Dream + Mood

      bool hasDream = dayEntries.any((e) => e.type == EntryType.dream);
      // We can take the average daily mood if multiple exists, or max.
      // Let's check if any entry has a mood.
      bool hasMood = dayEntries.any((e) => e.dailyMood != null);

      int level = 0;

      if (hasDream && hasMood) {
        level = 4;
      } else if (hasMood) {
        level = 3;
      } else if (hasDream) {
        level = 2;
      } else if (dayEntries.isNotEmpty) {
        level = 1;
      }

      heatmap[date] = level;
    });

    return heatmap;
  }
}
