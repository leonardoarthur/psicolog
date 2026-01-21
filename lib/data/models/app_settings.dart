import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = Isar.autoIncrement;

  bool isBiometricEnabled = false;

  // Singleton pattern helper for Isar
  static Future<AppSettings> get(Isar isar) async {
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
}
