import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/entry.dart';
import '../../logic/providers/journal_provider.dart';

import '../widgets/daily_check_in.dart';
import 'package:psicolog/l10n/app_localizations.dart';

import 'package:flutter_animate/flutter_animate.dart';

class MoodCalendarScreen extends StatefulWidget {
  const MoodCalendarScreen({super.key});

  @override
  State<MoodCalendarScreen> createState() => _MoodCalendarScreenState();
}

class _MoodCalendarScreenState extends State<MoodCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.moodCalendarTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, child) {
          final heatmapData = provider.getEmotionalHeatmap();

          return Column(
            children: [
              const DailyMoodSelector().animate().fadeIn(duration: 400.ms),
              HeatMapCalendar(
                datasets: heatmapData,
                colorMode: ColorMode.color,
                defaultColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
                showColorTip: false, // Clean look
                colorsets: {
                  1: Colors.redAccent,
                  2: Colors.orangeAccent,
                  3: Colors.amber,
                  4: Colors.lightGreen,
                  5: Colors.green,
                },
                onClick: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              const Divider(),
              Expanded(child: _buildDayList(provider, _selectedDate)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayList(JournalProvider provider, DateTime date) {
    // Filter entries for the selected date
    final dayEntries = provider.entries.where((e) {
      return e.timestamp.year == date.year &&
          e.timestamp.month == date.month &&
          e.timestamp.day == date.day;
    }).toList();

    if (dayEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                  Icons.event_note,
                  size: 48,
                  color: Colors.grey.withValues(alpha: 0.5),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 2000.ms,
                ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noRecordsOn(
                DateFormat(
                  'dd/MM',
                  Localizations.localeOf(context).toString(),
                ).format(date),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),
      );
    }

    return ListView.builder(
      itemCount: dayEntries.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final entry = dayEntries[index];
        return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: _getIconForType(entry.type),
                title: Text(
                  entry.title ?? AppLocalizations.of(context)!.untitled,
                ),
                subtitle: Text(
                  entry.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(DateFormat('HH:mm').format(entry.timestamp)),
              ),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: (50 * index).ms)
            .slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _getIconForType(EntryType type) {
    switch (type) {
      case EntryType.dream:
        return const Icon(Icons.cloud, color: Colors.purpleAccent);
      case EntryType.emotion:
        return const Icon(Icons.favorite, color: Colors.redAccent);
      case EntryType.insight:
        return const Icon(Icons.lightbulb, color: Colors.amber);
      case EntryType.therapy:
        return const Icon(Icons.self_improvement, color: Colors.teal);
    }
  }
}
