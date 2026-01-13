import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/entry.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([EntrySchema], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> addEntry(Entry entry) async {
    final isar = await db;
    // Ensure timestamp is set if not already
    // entry.timestamp = DateTime.now(); // Assuming caller sets it or we set it here if null?
    // Isar object fields are late, so we should expect a fully formed object or set defaults.
    // Let's assume the caller constructs it fully, except maybe ID.

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
}
