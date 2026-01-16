import 'package:flutter/foundation.dart';
import '../../data/models/entry.dart';
import '../../data/models/daily_mood.dart';
import '../../data/services/database_service.dart';

class JournalProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<Entry> _entries = [];
  List<DailyMood> _allDailyMoods = [];
  DailyMood? _todayMood;

  JournalProvider(this._databaseService) {
    _init();
  }

  List<Entry> get entries => _entries;
  DailyMood? get todayMood => _todayMood;

  void _init() {
    _databaseService.watchEntries().listen((entries) {
      _entries = entries;
      notifyListeners();
    });

    _databaseService.watchAllDailyMoods().listen((moods) {
      _allDailyMoods = moods;
      notifyListeners();
    });

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _databaseService.watchDailyMood(today).listen((mood) {
      _todayMood = mood;
      notifyListeners();
    });
  }

  Future<void> addEntry(Entry entry) async {
    await _databaseService.addEntry(entry);
  }

  Future<void> setDailyMood(int moodValue) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final mood = DailyMood()
      ..date = today
      ..mood = moodValue;

    // If we already have an ID for today (update case), Isar needs the ID.
    // But Isar's put() works as upsert if ID matches.
    // We need to fetch the existing one to get the ID if it exists?
    // Or we can rely on index unique replacement?
    // Isar doesn't automatically map by index for replacement unless we use 'replace: true' in index annotation.
    // Which I did: @Index(unique: true, replace: true)

    // However, if we just create a new DailyMood object, it has a new auto-increment ID.
    // If replace is true, Isar *should* replace the old one based on the index.
    // But typically it relies on ID. If 'replace: true' is set, it might delete the old one and insert the new one?
    // Or update the old one with the new data?
    // Let's verify Isar behavior or safer: get existing ID.

    final existing = await _databaseService.getDailyMood(today);
    if (existing != null) {
      mood.id = existing.id;
    }

    await _databaseService.saveDailyMood(mood);
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

    final Set<DateTime> allDates = entriesByDate.keys.toSet();
    for (var m in _allDailyMoods) {
      allDates.add(m.date);
    }

    final Map<DateTime, int> heatmap = {};

    for (var date in allDates) {
      final dayEntries = entriesByDate[date] ?? [];

      bool hasDream = dayEntries.any((e) => e.type == EntryType.dream);
      // Check legacy mood in entries OR new DailyMood model
      bool hasMood =
          dayEntries.any((e) => e.dailyMood != null) ||
          _allDailyMoods.any(
            (m) =>
                m.date.year == date.year &&
                m.date.month == date.month &&
                m.date.day == date.day,
          );

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
    }

    return heatmap;
  }
}
