import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entry.dart';
import '../models/daily_mood.dart';
import '../models/app_settings.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([
        EntrySchema,
        DailyMoodSchema,
        AppSettingsSchema,
      ], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveEntry(Entry entry) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });
  }

  // Alias for backward compatibility if needed, or just use saveEntry
  Future<void> addEntry(Entry entry) => saveEntry(entry);

  Future<void> deleteEntry(Id id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.delete(id);
    });
  }

  Future<List<Entry>> getEntries() async {
    final isar = await db;
    return await isar.entrys.where().sortByTimestampDesc().findAll();
  }

  Stream<List<Entry>> watchEntries() async* {
    final isar = await db;
    yield* isar.entrys.where().sortByIsPinnedDesc().thenByTimestampDesc().watch(
      fireImmediately: true,
    );
  }

  Future<void> restoreEntries(List<Entry> newEntries) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.clear(); // Clear existing entries? Or merge?
      // User decision usually implies replacement or add.
      // "Restore" typically means bringing back state. To be safe, let's keep it clean or just add.
      // If we clear, we lose current data not in backup.
      // Let's assume clear for now as it's a "Restore" action, typically destructive/replacing.
      // Or safer: putAll (upsert if IDs match, but here IDs are auto-increment so simple putAll adds duplicates if not careful).
      // Since JSON doesn't keep IDs, they are new entries.
      // Let's clear for now to avoid duplicates, assuming text backup is a full snapshot.
      await isar.entrys.clear();
      await isar.entrys.putAll(newEntries);
    });
  }

  // Daily Mood methods
  Future<void> saveDailyMood(DailyMood dailyMood) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.dailyMoods.put(dailyMood);
    });
  }

  Stream<DailyMood?> watchDailyMood(DateTime date) async* {
    final isar = await db;
    yield* isar.dailyMoods
        .where()
        .dateEqualTo(date)
        .watch(fireImmediately: true)
        .map((moods) => moods.isNotEmpty ? moods.first : null);
  }

  Stream<List<DailyMood>> watchAllDailyMoods() async* {
    final isar = await db;
    yield* isar.dailyMoods.where().watch(fireImmediately: true);
  }

  Future<DailyMood?> getDailyMood(DateTime date) async {
    final isar = await db;
    return await isar.dailyMoods.where().dateEqualTo(date).findFirst();
  }

  // Settings methods
  Future<AppSettings> getAppSettings() async {
    final isar = await db;
    final settings = await isar.appSettings.where().findFirst();
    if (settings == null) {
      final newSettings = AppSettings();
      await isar.writeTxn(() async {
        await isar.appSettings.put(newSettings);
      });
      return newSettings;
    }
    return settings;
  }

  Future<void> updateAppSettings(Function(AppSettings) updateFn) async {
    final isar = await db;
    final settings = await getAppSettings();
    await isar.writeTxn(() async {
      updateFn(settings);
      await isar.appSettings.put(settings);
    });
  }
}
