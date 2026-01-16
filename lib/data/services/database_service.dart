import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entry.dart';
import '../models/daily_mood.dart';

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
      ], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> addEntry(Entry entry) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.entrys.put(entry);
    });
  }

  Future<List<Entry>> getEntries() async {
    final isar = await db;
    return await isar.entrys.where().sortByTimestampDesc().findAll();
  }

  Stream<List<Entry>> watchEntries() async* {
    final isar = await db;
    yield* isar.entrys.where().sortByTimestampDesc().watch(
      fireImmediately: true,
    );
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
}
