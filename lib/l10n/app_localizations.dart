import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'PsicoLog'**
  String get appTitle;

  /// No description provided for @errorStartup.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao iniciar o aplicativo'**
  String get errorStartup;

  /// No description provided for @visitor.
  ///
  /// In pt, this message translates to:
  /// **'Visitante'**
  String get visitor;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'CONFIRMAR'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'CANCELAR'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'EXCLUIR'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @journalEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Seu diário está vazio.'**
  String get journalEmpty;

  /// No description provided for @registerDream.
  ///
  /// In pt, this message translates to:
  /// **'Registrar Sonho'**
  String get registerDream;

  /// No description provided for @dreamSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'O que você sonhou essa noite?'**
  String get dreamSubtitle;

  /// No description provided for @newInsight.
  ///
  /// In pt, this message translates to:
  /// **'Novo Insight'**
  String get newInsight;

  /// No description provided for @insightSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Uma ideia ou percepção.'**
  String get insightSubtitle;

  /// No description provided for @dream.
  ///
  /// In pt, this message translates to:
  /// **'Sonho'**
  String get dream;

  /// No description provided for @insight.
  ///
  /// In pt, this message translates to:
  /// **'Insight'**
  String get insight;

  /// No description provided for @emotion.
  ///
  /// In pt, this message translates to:
  /// **'Emoção'**
  String get emotion;

  /// No description provided for @therapy.
  ///
  /// In pt, this message translates to:
  /// **'Terapia'**
  String get therapy;

  /// No description provided for @wakeUpMood.
  ///
  /// In pt, this message translates to:
  /// **'Humor ao acordar'**
  String get wakeUpMood;

  /// No description provided for @associations.
  ///
  /// In pt, this message translates to:
  /// **'Associações'**
  String get associations;

  /// No description provided for @pin.
  ///
  /// In pt, this message translates to:
  /// **'Fixar'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In pt, this message translates to:
  /// **'Desafixar'**
  String get unpin;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir entrada?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryContent.
  ///
  /// In pt, this message translates to:
  /// **'Essa ação não pode ser desfeita.'**
  String get deleteEntryContent;

  /// No description provided for @goodMorning.
  ///
  /// In pt, this message translates to:
  /// **'Bom dia'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In pt, this message translates to:
  /// **'Boa tarde'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In pt, this message translates to:
  /// **'Boa noite'**
  String get goodEvening;

  /// No description provided for @dreamPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Pronto para registrar seus sonhos?'**
  String get dreamPrompt;

  /// No description provided for @recordDreamNow.
  ///
  /// In pt, this message translates to:
  /// **'GRAVAR SONHO AGORA'**
  String get recordDreamNow;

  /// No description provided for @noDreamsYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum sonho registrado ainda.'**
  String get noDreamsYet;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @therapySectionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Terapia e Bem-Estar'**
  String get therapySectionTitle;

  /// No description provided for @darkMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Alternar tema do aplicativo'**
  String get darkModeSubtitle;

  /// No description provided for @biometrics.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueio Biométrico'**
  String get biometrics;

  /// No description provided for @biometricsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Exigir autenticação ao abrir o app'**
  String get biometricsSubtitle;

  /// No description provided for @exportData.
  ///
  /// In pt, this message translates to:
  /// **'Exportar Dados'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Salvar backup em arquivo JSON'**
  String get exportDataSubtitle;

  /// No description provided for @restoreData.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar Dados'**
  String get restoreData;

  /// No description provided for @restoreDataSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Importar de arquivo JSON'**
  String get restoreDataSubtitle;

  /// No description provided for @therapySchedule.
  ///
  /// In pt, this message translates to:
  /// **'Horário da Terapia'**
  String get therapySchedule;

  /// No description provided for @tapToConfigure.
  ///
  /// In pt, this message translates to:
  /// **'Toque para configurar'**
  String get tapToConfigure;

  /// No description provided for @testNotification.
  ///
  /// In pt, this message translates to:
  /// **'Testar Notificação'**
  String get testNotification;

  /// No description provided for @testNotificationSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Disparar notificação agora'**
  String get testNotificationSubtitle;

  /// No description provided for @checkSchedule.
  ///
  /// In pt, this message translates to:
  /// **'Verificar Agendamentos'**
  String get checkSchedule;

  /// No description provided for @checkScheduleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Listar horários agendados'**
  String get checkScheduleSubtitle;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Biometria não disponível neste dispositivo.'**
  String get biometricsNotAvailable;

  /// No description provided for @backupSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup gerado com sucesso!'**
  String get backupSuccess;

  /// No description provided for @backupError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao exportar: {error}'**
  String backupError(String error);

  /// No description provided for @restoreSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Dados restaurados com sucesso! Reinicie o app.'**
  String get restoreSuccess;

  /// No description provided for @restoreError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao restaurar: {error}'**
  String restoreError(String error);

  /// No description provided for @notificationSent.
  ///
  /// In pt, this message translates to:
  /// **'Notificação de teste enviada!'**
  String get notificationSent;

  /// No description provided for @noScheduleFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum agendamento encontrado.'**
  String get noScheduleFound;

  /// No description provided for @schedulesFound.
  ///
  /// In pt, this message translates to:
  /// **'Agendamentos: {count} pendentes'**
  String schedulesFound(int count);

  /// No description provided for @therapyDayTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dia da Terapia'**
  String get therapyDayTitle;

  /// No description provided for @catharsisTitle.
  ///
  /// In pt, this message translates to:
  /// **'Catarse'**
  String get catharsisTitle;

  /// No description provided for @catharsisInstruction.
  ///
  /// In pt, this message translates to:
  /// **'Escreva o que te aflige. Ao liberar, desaparecerá para sempre.'**
  String get catharsisInstruction;

  /// No description provided for @typeHere.
  ///
  /// In pt, this message translates to:
  /// **'Digite aqui...'**
  String get typeHere;

  /// No description provided for @liberateThought.
  ///
  /// In pt, this message translates to:
  /// **'Liberar Pensamento'**
  String get liberateThought;

  /// No description provided for @thoughtLiberated.
  ///
  /// In pt, this message translates to:
  /// **'Pensamento liberado.'**
  String get thoughtLiberated;

  /// No description provided for @monday.
  ///
  /// In pt, this message translates to:
  /// **'Segunda-feira'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In pt, this message translates to:
  /// **'Terça-feira'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In pt, this message translates to:
  /// **'Quarta-feira'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In pt, this message translates to:
  /// **'Quinta-feira'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In pt, this message translates to:
  /// **'Sexta-feira'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In pt, this message translates to:
  /// **'Sábado'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In pt, this message translates to:
  /// **'Domingo'**
  String get sunday;

  /// No description provided for @navDreams.
  ///
  /// In pt, this message translates to:
  /// **'Sonhos'**
  String get navDreams;

  /// No description provided for @navJournal.
  ///
  /// In pt, this message translates to:
  /// **'Diário'**
  String get navJournal;

  /// No description provided for @navTherapy.
  ///
  /// In pt, this message translates to:
  /// **'Terapia'**
  String get navTherapy;

  /// No description provided for @navEchoes.
  ///
  /// In pt, this message translates to:
  /// **'Ecos'**
  String get navEchoes;

  /// No description provided for @myTherapy.
  ///
  /// In pt, this message translates to:
  /// **'Minha Terapia'**
  String get myTherapy;

  /// No description provided for @noTherapyRecorded.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma sessão registrada.'**
  String get noTherapyRecorded;

  /// No description provided for @newSession.
  ///
  /// In pt, this message translates to:
  /// **'Nova Sessão'**
  String get newSession;

  /// No description provided for @reflection.
  ///
  /// In pt, this message translates to:
  /// **'REFLEXÃO'**
  String get reflection;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir sessão?'**
  String get deleteSessionTitle;

  /// No description provided for @moodCalendarTitle.
  ///
  /// In pt, this message translates to:
  /// **'Calendário Emocional'**
  String get moodCalendarTitle;

  /// No description provided for @noRecordsOn.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum registro em {date}'**
  String noRecordsOn(String date);

  /// No description provided for @untitled.
  ///
  /// In pt, this message translates to:
  /// **'Sem título'**
  String get untitled;

  /// No description provided for @echoesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Escreva mais no seu diário para ver os significantes aparecerem aqui.'**
  String get echoesEmpty;

  /// No description provided for @howWasYourDay.
  ///
  /// In pt, this message translates to:
  /// **'Como foi seu dia?'**
  String get howWasYourDay;

  /// No description provided for @writeSomethingToSave.
  ///
  /// In pt, this message translates to:
  /// **'Escreva algo para salvar.'**
  String get writeSomethingToSave;

  /// No description provided for @dreamTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do Sonho (Opcional)'**
  String get dreamTitleHint;

  /// No description provided for @insightTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Título do Insight'**
  String get insightTitleHint;

  /// No description provided for @emotionTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Humor'**
  String get emotionTitleHint;

  /// No description provided for @therapyTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Título da Sessão (Opcional)'**
  String get therapyTitleHint;

  /// No description provided for @dreamContentHint.
  ///
  /// In pt, this message translates to:
  /// **'Relato do sonho...'**
  String get dreamContentHint;

  /// No description provided for @insightContentHint.
  ///
  /// In pt, this message translates to:
  /// **'Descreva seu insight...'**
  String get insightContentHint;

  /// No description provided for @emotionContentHint.
  ///
  /// In pt, this message translates to:
  /// **'Observação sobre o dia (opcional)'**
  String get emotionContentHint;

  /// No description provided for @therapyContentHint.
  ///
  /// In pt, this message translates to:
  /// **'Fale um pouco sobre a sessão...'**
  String get therapyContentHint;

  /// No description provided for @newDream.
  ///
  /// In pt, this message translates to:
  /// **'Novo Sonho'**
  String get newDream;

  /// No description provided for @newTherapy.
  ///
  /// In pt, this message translates to:
  /// **'Nova Sessão'**
  String get newTherapy;

  /// No description provided for @newEmotion.
  ///
  /// In pt, this message translates to:
  /// **'Novo Humor'**
  String get newEmotion;

  /// No description provided for @editDream.
  ///
  /// In pt, this message translates to:
  /// **'Editar Sonho'**
  String get editDream;

  /// No description provided for @editInsight.
  ///
  /// In pt, this message translates to:
  /// **'Editar Insight'**
  String get editInsight;

  /// No description provided for @editTherapy.
  ///
  /// In pt, this message translates to:
  /// **'Editar Sessão'**
  String get editTherapy;

  /// No description provided for @editEmotion.
  ///
  /// In pt, this message translates to:
  /// **'Editar Emoção'**
  String get editEmotion;

  /// No description provided for @howDidYouWakeUp.
  ///
  /// In pt, this message translates to:
  /// **'Como acordou?'**
  String get howDidYouWakeUp;

  /// No description provided for @moodTired.
  ///
  /// In pt, this message translates to:
  /// **'Cansado'**
  String get moodTired;

  /// No description provided for @moodGood.
  ///
  /// In pt, this message translates to:
  /// **'Bem'**
  String get moodGood;

  /// No description provided for @moodEnergized.
  ///
  /// In pt, this message translates to:
  /// **'Energizado'**
  String get moodEnergized;

  /// No description provided for @moodScared.
  ///
  /// In pt, this message translates to:
  /// **'Assustado'**
  String get moodScared;

  /// No description provided for @moodConfused.
  ///
  /// In pt, this message translates to:
  /// **'Confuso'**
  String get moodConfused;

  /// No description provided for @tagsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tags'**
  String get tagsLabel;

  /// No description provided for @tagNightmare.
  ///
  /// In pt, this message translates to:
  /// **'Pesadelo'**
  String get tagNightmare;

  /// No description provided for @tagLucid.
  ///
  /// In pt, this message translates to:
  /// **'Lúcido'**
  String get tagLucid;

  /// No description provided for @tagRecurrent.
  ///
  /// In pt, this message translates to:
  /// **'Recorrente'**
  String get tagRecurrent;

  /// No description provided for @tagFragmented.
  ///
  /// In pt, this message translates to:
  /// **'Fragmentado'**
  String get tagFragmented;

  /// No description provided for @tagPremonition.
  ///
  /// In pt, this message translates to:
  /// **'Premonição'**
  String get tagPremonition;

  /// No description provided for @reflectionQuestion.
  ///
  /// In pt, this message translates to:
  /// **'O que mais te fez refletir dessa vez?'**
  String get reflectionQuestion;

  /// No description provided for @reflectionHint.
  ///
  /// In pt, this message translates to:
  /// **'O que você quer lembrar dessa sessão?'**
  String get reflectionHint;

  /// No description provided for @associationsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Associações / Resto Diurno'**
  String get associationsLabel;

  /// No description provided for @associationsHint.
  ///
  /// In pt, this message translates to:
  /// **'O que aconteceu ontem que pode ter puxado isso?'**
  String get associationsHint;

  /// No description provided for @seeMore.
  ///
  /// In pt, this message translates to:
  /// **'Ver mais'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In pt, this message translates to:
  /// **'Ver menos'**
  String get seeLess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
