import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/entry.dart';
import '../../logic/providers/journal_provider.dart';

import '../widgets/daily_check_in.dart';

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
        title: const Text('Calendário Emocional'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<JournalProvider>(
        builder: (context, provider, child) {
          final heatmapData = provider.getEmotionalHeatmap();

          return Column(
            children: [
              const DailyMoodSelector(),
              HeatMapCalendar(
                datasets: heatmapData,
                colorMode: ColorMode.color,
                defaultColor: Theme.of(context).cardColor,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
                showColorTip: false, // Clean look
                colorsets: {
                  1: Colors.grey[300]!,
                  2: Colors.purpleAccent,
                  3: Colors.orange,
                  4: Colors.red[800]!,
                },
                onClick: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
              ),
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
        child: Text(
          'Nenhum registro em ${DateFormat('dd/MM').format(date)}',
          style: const TextStyle(color: Colors.grey),
        ),
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
            title: Text(entry.title ?? 'Sem título'),
            subtitle: Text(
              entry.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(DateFormat('HH:mm').format(entry.timestamp)),
          ),
        );
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
    }
  }
}
