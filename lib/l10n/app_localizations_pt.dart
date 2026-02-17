// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'PsicoLog';

  @override
  String get errorStartup => 'Erro ao iniciar o aplicativo';

  @override
  String get visitor => 'Visitante';

  @override
  String get confirm => 'CONFIRMAR';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get delete => 'EXCLUIR';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get journalEmpty => 'Seu diário está vazio.';

  @override
  String get registerDream => 'Registrar Sonho';

  @override
  String get dreamSubtitle => 'O que você sonhou essa noite?';

  @override
  String get newInsight => 'Novo Insight';

  @override
  String get insightSubtitle => 'Uma ideia ou percepção.';

  @override
  String get dream => 'Sonho';

  @override
  String get insight => 'Insight';

  @override
  String get emotion => 'Emoção';

  @override
  String get therapy => 'Terapia';

  @override
  String get wakeUpMood => 'Humor ao acordar';

  @override
  String get associations => 'Associações';

  @override
  String get pin => 'Fixar';

  @override
  String get unpin => 'Desafixar';

  @override
  String get deleteEntryTitle => 'Excluir entrada?';

  @override
  String get deleteEntryContent => 'Essa ação não pode ser desfeita.';

  @override
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String get dreamPrompt => 'Pronto para registrar seus sonhos?';

  @override
  String get recordDreamNow => 'GRAVAR SONHO AGORA';

  @override
  String get noDreamsYet => 'Nenhum sonho registrado ainda.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get therapySectionTitle => 'Terapia e Bem-Estar';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get darkModeSubtitle => 'Alternar tema do aplicativo';

  @override
  String get biometrics => 'Bloqueio Biométrico';

  @override
  String get biometricsSubtitle => 'Exigir autenticação ao abrir o app';

  @override
  String get exportData => 'Exportar Dados';

  @override
  String get exportDataSubtitle => 'Salvar backup em arquivo JSON';

  @override
  String get restoreData => 'Restaurar Dados';

  @override
  String get restoreDataSubtitle => 'Importar de arquivo JSON';

  @override
  String get therapySchedule => 'Horário da Terapia';

  @override
  String get tapToConfigure => 'Toque para configurar';

  @override
  String get testNotification => 'Testar Notificação';

  @override
  String get testNotificationSubtitle => 'Disparar notificação agora';

  @override
  String get checkSchedule => 'Verificar Agendamentos';

  @override
  String get checkScheduleSubtitle => 'Listar horários agendados';

  @override
  String get biometricsNotAvailable =>
      'Biometria não disponível neste dispositivo.';

  @override
  String get backupSuccess => 'Backup gerado com sucesso!';

  @override
  String backupError(String error) {
    return 'Erro ao exportar: $error';
  }

  @override
  String get restoreSuccess => 'Dados restaurados com sucesso! Reinicie o app.';

  @override
  String restoreError(String error) {
    return 'Erro ao restaurar: $error';
  }

  @override
  String get notificationSent => 'Notificação de teste enviada!';

  @override
  String get noScheduleFound => 'Nenhum agendamento encontrado.';

  @override
  String schedulesFound(int count) {
    return 'Agendamentos: $count pendentes';
  }

  @override
  String get therapyDayTitle => 'Dia da Terapia';

  @override
  String get catharsisTitle => 'Catarse';

  @override
  String get catharsisInstruction =>
      'Escreva o que te aflige. Ao liberar, desaparecerá para sempre.';

  @override
  String get typeHere => 'Digite aqui...';

  @override
  String get liberateThought => 'Liberar Pensamento';

  @override
  String get thoughtLiberated => 'Pensamento liberado.';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get tuesday => 'Terça-feira';

  @override
  String get wednesday => 'Quarta-feira';

  @override
  String get thursday => 'Quinta-feira';

  @override
  String get friday => 'Sexta-feira';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get navDreams => 'Sonhos';

  @override
  String get navJournal => 'Diário';

  @override
  String get navTherapy => 'Terapia';

  @override
  String get navEchoes => 'Ecos';

  @override
  String get myTherapy => 'Minha Terapia';

  @override
  String get noTherapyRecorded => 'Nenhuma sessão registrada.';

  @override
  String get newSession => 'Nova Sessão';

  @override
  String get reflection => 'REFLEXÃO';

  @override
  String get deleteSessionTitle => 'Excluir sessão?';

  @override
  String get moodCalendarTitle => 'Calendário Emocional';

  @override
  String noRecordsOn(String date) {
    return 'Nenhum registro em $date';
  }

  @override
  String get untitled => 'Sem título';

  @override
  String get echoesEmpty =>
      'Escreva mais no seu diário para ver os significantes aparecerem aqui.';

  @override
  String get howWasYourDay => 'Como foi seu dia?';

  @override
  String get writeSomethingToSave => 'Escreva algo para salvar.';

  @override
  String get dreamTitleHint => 'Nome do Sonho (Opcional)';

  @override
  String get insightTitleHint => 'Título do Insight';

  @override
  String get emotionTitleHint => 'Humor';

  @override
  String get therapyTitleHint => 'Título da Sessão (Opcional)';

  @override
  String get dreamContentHint => 'Relato do sonho...';

  @override
  String get insightContentHint => 'Descreva seu insight...';

  @override
  String get emotionContentHint => 'Observação sobre o dia (opcional)';

  @override
  String get therapyContentHint => 'Fale um pouco sobre a sessão...';

  @override
  String get newDream => 'Novo Sonho';

  @override
  String get newTherapy => 'Nova Sessão';

  @override
  String get newEmotion => 'Novo Humor';

  @override
  String get editDream => 'Editar Sonho';

  @override
  String get editInsight => 'Editar Insight';

  @override
  String get editTherapy => 'Editar Sessão';

  @override
  String get editEmotion => 'Editar Emoção';

  @override
  String get howDidYouWakeUp => 'Como acordou?';

  @override
  String get moodTired => 'Cansado';

  @override
  String get moodGood => 'Bem';

  @override
  String get moodEnergized => 'Energizado';

  @override
  String get moodScared => 'Assustado';

  @override
  String get moodConfused => 'Confuso';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get tagNightmare => 'Pesadelo';

  @override
  String get tagLucid => 'Lúcido';

  @override
  String get tagRecurrent => 'Recorrente';

  @override
  String get tagFragmented => 'Fragmentado';

  @override
  String get tagPremonition => 'Premonição';

  @override
  String get reflectionQuestion => 'O que mais te fez refletir dessa vez?';

  @override
  String get reflectionHint => 'O que você quer lembrar dessa sessão?';

  @override
  String get associationsLabel => 'Associações / Resto Diurno';

  @override
  String get associationsHint =>
      'O que aconteceu ontem que pode ter puxado isso?';

  @override
  String get seeMore => 'Ver mais';

  @override
  String get seeLess => 'Ver menos';

  @override
  String get supportMe => 'Apoie o Projeto';

  @override
  String get supportMeSubtitle => 'Pague um café no Ko-fi';

  @override
  String get privacyPolicy => 'Política de Privacidade';
}
