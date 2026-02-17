// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PsicoLog';

  @override
  String get errorStartup => 'Error starting application';

  @override
  String get visitor => 'Visitor';

  @override
  String get confirm => 'CONFIRM';

  @override
  String get cancel => 'CANCEL';

  @override
  String get delete => 'DELETE';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get journalEmpty => 'Your journal is empty.';

  @override
  String get registerDream => 'Log Dream';

  @override
  String get dreamSubtitle => 'What did you dream last night?';

  @override
  String get newInsight => 'New Insight';

  @override
  String get insightSubtitle => 'An idea or perception.';

  @override
  String get dream => 'Dream';

  @override
  String get insight => 'Insight';

  @override
  String get emotion => 'Emotion';

  @override
  String get therapy => 'Therapy';

  @override
  String get wakeUpMood => 'Wake up mood';

  @override
  String get associations => 'Associations';

  @override
  String get pin => 'Pin';

  @override
  String get unpin => 'Unpin';

  @override
  String get deleteEntryTitle => 'Delete entry?';

  @override
  String get deleteEntryContent => 'This action cannot be undone.';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get dreamPrompt => 'Ready to log your dreams?';

  @override
  String get recordDreamNow => 'LOG DREAM NOW';

  @override
  String get noDreamsYet => 'No dreams logged yet.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get therapySectionTitle => 'Therapy & Well-being';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeSubtitle => 'Toggle app theme';

  @override
  String get biometrics => 'Biometric Lock';

  @override
  String get biometricsSubtitle => 'Require authentication to open app';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Save backup to JSON file';

  @override
  String get restoreData => 'Restore Data';

  @override
  String get restoreDataSubtitle => 'Import from JSON file';

  @override
  String get therapySchedule => 'Therapy Schedule';

  @override
  String get tapToConfigure => 'Tap to configure';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get testNotificationSubtitle => 'Trigger notification now';

  @override
  String get checkSchedule => 'Check Schedules';

  @override
  String get checkScheduleSubtitle => 'List scheduled times';

  @override
  String get biometricsNotAvailable =>
      'Biometrics not available on this device.';

  @override
  String get backupSuccess => 'Backup created successfully!';

  @override
  String backupError(String error) {
    return 'Error exporting: $error';
  }

  @override
  String get restoreSuccess => 'Data restored successfully! Restart app.';

  @override
  String restoreError(String error) {
    return 'Error restoring: $error';
  }

  @override
  String get notificationSent => 'Test notification sent!';

  @override
  String get noScheduleFound => 'No schedules found.';

  @override
  String schedulesFound(int count) {
    return 'Schedules: $count pending';
  }

  @override
  String get therapyDayTitle => 'Therapy Day';

  @override
  String get catharsisTitle => 'Catharsis';

  @override
  String get catharsisInstruction =>
      'Write what afflicts you. Upon release, it will disappear forever.';

  @override
  String get typeHere => 'Type here...';

  @override
  String get liberateThought => 'Release Thought';

  @override
  String get thoughtLiberated => 'Thought released.';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get navDreams => 'Dreams';

  @override
  String get navJournal => 'Journal';

  @override
  String get navTherapy => 'Therapy';

  @override
  String get navEchoes => 'Echoes';

  @override
  String get myTherapy => 'My Therapy';

  @override
  String get noTherapyRecorded => 'No therapy recorded.';

  @override
  String get newSession => 'New Session';

  @override
  String get reflection => 'REFLECTION';

  @override
  String get deleteSessionTitle => 'Delete session?';

  @override
  String get moodCalendarTitle => 'Mood Calendar';

  @override
  String noRecordsOn(String date) {
    return 'No records on $date';
  }

  @override
  String get untitled => 'Untitled';

  @override
  String get echoesEmpty =>
      'Write more in your journal to see significant words appear here.';

  @override
  String get howWasYourDay => 'How was your day?';

  @override
  String get writeSomethingToSave => 'Write something to save.';

  @override
  String get dreamTitleHint => 'Dream Name (Optional)';

  @override
  String get insightTitleHint => 'Insight Title';

  @override
  String get emotionTitleHint => 'Mood';

  @override
  String get therapyTitleHint => 'Session Title (Optional)';

  @override
  String get dreamContentHint => 'Dream report...';

  @override
  String get insightContentHint => 'Describe your insight...';

  @override
  String get emotionContentHint => 'Note about the day (optional)';

  @override
  String get therapyContentHint => 'Talk a bit about the session...';

  @override
  String get newDream => 'New Dream';

  @override
  String get newTherapy => 'New Session';

  @override
  String get newEmotion => 'New Mood';

  @override
  String get editDream => 'Edit Dream';

  @override
  String get editInsight => 'Edit Insight';

  @override
  String get editTherapy => 'Edit Session';

  @override
  String get editEmotion => 'Edit Mood';

  @override
  String get howDidYouWakeUp => 'How did you wake up?';

  @override
  String get moodTired => 'Tired';

  @override
  String get moodGood => 'Good';

  @override
  String get moodEnergized => 'Energized';

  @override
  String get moodScared => 'Scared';

  @override
  String get moodConfused => 'Confused';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get tagNightmare => 'Nightmare';

  @override
  String get tagLucid => 'Lucid';

  @override
  String get tagRecurrent => 'Recurrent';

  @override
  String get tagFragmented => 'Fragmented';

  @override
  String get tagPremonition => 'Premonition';

  @override
  String get reflectionQuestion => 'What made you reflect the most this time?';

  @override
  String get reflectionHint =>
      'What do you want to remember from this session?';

  @override
  String get associationsLabel => 'Associations / Day Residue';

  @override
  String get associationsHint =>
      'What happened yesterday that might have triggered this?';

  @override
  String get seeMore => 'See more';

  @override
  String get seeLess => 'See less';

  @override
  String get supportMe => 'Support the Project';

  @override
  String get supportMeSubtitle => 'Buy me a coffee on Ko-fi';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
