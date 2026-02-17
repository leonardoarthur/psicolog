// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PsicoLog';

  @override
  String get errorStartup => 'Error al iniciar la aplicación';

  @override
  String get visitor => 'Visitante';

  @override
  String get confirm => 'CONFIRMAR';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get delete => 'ELIMINAR';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get journalEmpty => 'Tu diario está vacío.';

  @override
  String get registerDream => 'Registrar Sueño';

  @override
  String get dreamSubtitle => '¿Qué soñaste anoche?';

  @override
  String get newInsight => 'Nuevo Insight';

  @override
  String get insightSubtitle => 'Una idea o percepción.';

  @override
  String get dream => 'Sueño';

  @override
  String get insight => 'Insight';

  @override
  String get emotion => 'Emoción';

  @override
  String get therapy => 'Terapia';

  @override
  String get wakeUpMood => 'Humor al despertar';

  @override
  String get associations => 'Asociaciones';

  @override
  String get pin => 'Fijar';

  @override
  String get unpin => 'Desfijar';

  @override
  String get deleteEntryTitle => '¿Eliminar entrada?';

  @override
  String get deleteEntryContent => 'Esta acción no se puede deshacer.';

  @override
  String get goodMorning => 'Buenos días';

  @override
  String get goodAfternoon => 'Buenas tardes';

  @override
  String get goodEvening => 'Buenas noches';

  @override
  String get dreamPrompt => '¿Listo para registrar tus sueños?';

  @override
  String get recordDreamNow => 'GRABAR SUEÑO AHORA';

  @override
  String get noDreamsYet => 'Aún no hay sueños registrados.';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get therapySectionTitle => 'Terapia y Bienestar';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get darkModeSubtitle => 'Cambiar tema de la aplicación';

  @override
  String get biometrics => 'Bloqueo Biométrico';

  @override
  String get biometricsSubtitle => 'Exigir autenticación al abrir la app';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get exportDataSubtitle => 'Guardar copia de seguridad en archivo JSON';

  @override
  String get restoreData => 'Restaurar Datos';

  @override
  String get restoreDataSubtitle => 'Importar desde archivo JSON';

  @override
  String get therapySchedule => 'Horario de Terapia';

  @override
  String get tapToConfigure => 'Toque para configurar';

  @override
  String get testNotification => 'Probar Notificación';

  @override
  String get testNotificationSubtitle => 'Disparar notificación ahora';

  @override
  String get checkSchedule => 'Verificar Programación';

  @override
  String get checkScheduleSubtitle => 'Listar horarios programados';

  @override
  String get biometricsNotAvailable =>
      'Biometría no disponible en este dispositivo.';

  @override
  String get backupSuccess => '¡Copia de seguridad creada con éxito!';

  @override
  String backupError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get restoreSuccess => '¡Datos restaurados con éxito! Reinicia la app.';

  @override
  String restoreError(String error) {
    return 'Error al restaurar: $error';
  }

  @override
  String get notificationSent => '¡Notificación de prueba enviada!';

  @override
  String get noScheduleFound => 'No se encontraron horarios.';

  @override
  String schedulesFound(int count) {
    return 'Horarios: $count pendientes';
  }

  @override
  String get therapyDayTitle => 'Día de Terapia';

  @override
  String get catharsisTitle => 'Catarsis';

  @override
  String get catharsisInstruction =>
      'Escribe lo que te aflige. Al liberar, desaparecerá para siempre.';

  @override
  String get typeHere => 'Escribe aquí...';

  @override
  String get liberateThought => 'Liberar Pensamiento';

  @override
  String get thoughtLiberated => 'Pensamiento liberado.';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get navDreams => 'Sueños';

  @override
  String get navJournal => 'Diario';

  @override
  String get navTherapy => 'Terapia';

  @override
  String get navEchoes => 'Ecos';

  @override
  String get myTherapy => 'Mi Terapia';

  @override
  String get noTherapyRecorded => 'Ninguna sesión registrada.';

  @override
  String get newSession => 'Nueva Sesión';

  @override
  String get reflection => 'REFLEXIÓN';

  @override
  String get deleteSessionTitle => '¿Eliminar sesión?';

  @override
  String get moodCalendarTitle => 'Calendario Emocional';

  @override
  String noRecordsOn(String date) {
    return 'Ningún registro el $date';
  }

  @override
  String get untitled => 'Sin título';

  @override
  String get echoesEmpty =>
      'Escribe más en tu diario para ver aparecer las palabras significantes aquí.';

  @override
  String get howWasYourDay => '¿Cómo fue tu día?';

  @override
  String get writeSomethingToSave => 'Escribe algo para guardar.';

  @override
  String get dreamTitleHint => 'Nombre del Sueño (Opcional)';

  @override
  String get insightTitleHint => 'Título del Insight';

  @override
  String get emotionTitleHint => 'Humor';

  @override
  String get therapyTitleHint => 'Título de la Sesión (Opcional)';

  @override
  String get dreamContentHint => 'Relato del sueño...';

  @override
  String get insightContentHint => 'Describe tu insight...';

  @override
  String get emotionContentHint => 'Nota sobre el día (opcional)';

  @override
  String get therapyContentHint => 'Habla un poco sobre la sesión...';

  @override
  String get newDream => 'Nuevo Sueño';

  @override
  String get newTherapy => 'Nueva Sesión';

  @override
  String get newEmotion => 'Nuevo Humor';

  @override
  String get editDream => 'Editar Sueño';

  @override
  String get editInsight => 'Editar Insight';

  @override
  String get editTherapy => 'Editar Sesión';

  @override
  String get editEmotion => 'Editar Emoción';

  @override
  String get howDidYouWakeUp => '¿Cómo despertaste?';

  @override
  String get moodTired => 'Cansado';

  @override
  String get moodGood => 'Bien';

  @override
  String get moodEnergized => 'Energizado';

  @override
  String get moodScared => 'Asustado';

  @override
  String get moodConfused => 'Confundido';

  @override
  String get tagsLabel => 'Etiquetas';

  @override
  String get tagNightmare => 'Pesadilla';

  @override
  String get tagLucid => 'Lúcido';

  @override
  String get tagRecurrent => 'Recurrente';

  @override
  String get tagFragmented => 'Fragmentado';

  @override
  String get tagPremonition => 'Premonición';

  @override
  String get reflectionQuestion => '¿Qué te hizo reflexionar más esta vez?';

  @override
  String get reflectionHint => '¿Qué quieres recordar de esta sesión?';

  @override
  String get associationsLabel => 'Asociaciones / Resto Diurno';

  @override
  String get associationsHint =>
      '¿Qué pasó ayer que pudo haber provocado esto?';

  @override
  String get seeMore => 'Ver más';

  @override
  String get seeLess => 'Ver menos';

  @override
  String get supportMe => 'Apoya el Proyecto';

  @override
  String get supportMeSubtitle => 'Cómprame un café en Ko-fi';

  @override
  String get privacyPolicy => 'Política de Privacidad';
}
