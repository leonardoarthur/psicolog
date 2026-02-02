import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/services/database_service.dart';
import '../../data/models/entry.dart';
import '../../services/logger_service.dart';

class BackupService {
  final DatabaseService _databaseService;

  BackupService(this._databaseService);

  // Methods removed to revert auto backup logic

  Future<void> exportData() async {
    // 1. Fetch all data
    final entries = await _databaseService.getEntries();

    // Convert to JSON-encodable map
    final data = {
      'version': 1,
      'timestamp': DateTime.now().toIso8601String(),
      'entries': entries.map((e) => _entryToMap(e)).toList(),
    };

    final jsonString = jsonEncode(data);

    // 2. Save to file
    final directory = await getApplicationDocumentsDirectory();
    final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'psicolog_backup_$dateStr.json';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(jsonString);

    // 3. Share/Save dialog
    await Share.shareXFiles([XFile(file.path)], text: 'PsicoLog Backup');
  }

  Future<bool> restoreData() async {
    // 1. Pick file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();

    try {
      final data = jsonDecode(jsonString);
      if (data['version'] != 1) {
        throw Exception('Versão de backup incompatível');
      }

      final List<dynamic> entriesJson = data['entries'] ?? [];

      final List<Entry> newEntries = entriesJson
          .map((e) => _mapToEntry(e))
          .toList();

      // 2. Import to DB
      await _databaseService.restoreEntries(newEntries);

      return true;
    } catch (e, stack) {
      LoggerService.log('Erro ao restaurar: $e', e, stack);
      return false;
    }
  }

  // Helpers (Manual JSON since Isar models don't auto-generate toJson/fromJson easily without freeze or similar)
  Map<String, dynamic> _entryToMap(Entry e) {
    return {
      'content': e.content,
      'timestamp': e.timestamp.toIso8601String(),
      'type': e.type.index, // Enum index
      'title': e.title,
      'dreamFeelings': e.dreamFeelings,
      'dreamAssociations': e.dreamAssociations,
      'wakeUpMood': e.wakeUpMood,
      'dailyMood': e.dailyMood,
      'dreamTags': e.dreamTags,
    };
  }

  Entry _mapToEntry(Map<String, dynamic> map) {
    return Entry()
      ..content = map['content']
      ..timestamp = DateTime.parse(map['timestamp'])
      ..type = EntryType.values[map['type']]
      ..title = map['title']
      ..dreamFeelings = map['dreamFeelings']
      ..dreamAssociations = map['dreamAssociations']
      ..wakeUpMood = map['wakeUpMood']
      ..dailyMood = map['dailyMood']
      ..dreamTags = (map['dreamTags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList();
  }
}
