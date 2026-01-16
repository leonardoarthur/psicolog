import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import 'mood_calendar_screen.dart';
import '../widgets/entry_form.dart';
import '../widgets/daily_check_in.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade50, // Lighter background for contrast with cards
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const DailyCheckInWidget(),
            Expanded(
              child: Consumer<JournalProvider>(
                builder: (context, provider, child) {
                  final entries = provider.entries;
                  if (entries.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.book_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Seu diário está vazio.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16, bottom: 80),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return _EntryCard(entry: entry);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenu(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    // Format: "Segunda, 12 Out"
    final dayName = DateFormat(
      'EEEE',
      'pt_BR',
    ).format(now).split('-')[0]; // Remove -feira
    final dayNum = DateFormat('d', 'pt_BR').format(now);
    final month = DateFormat('MMM', 'pt_BR').format(now);
    final dateStr =
        "${dayName[0].toUpperCase()}${dayName.substring(1)}, $dayNum ${month[0].toUpperCase()}${month.substring(1)}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateStr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoodCalendarScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month, color: Colors.grey),
              ),
              IconButton(
                onPressed: () {
                  // Settings placeholder
                },
                icon: const Icon(Icons.settings, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.nights_stay,
                  color: Colors.deepPurple,
                ),
                title: const Text('Registrar Sonho'),
                subtitle: const Text('O que você sonhou essa noite?'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.dream);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.amber),
                title: const Text('Novo Insight'),
                subtitle: const Text('Uma ideia ou percepção.'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.insight);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.redAccent),
                title: const Text('Emoção Intensa'),
                subtitle: const Text('Registre o que está sentindo.'),
                onTap: () {
                  Navigator.pop(context);
                  _showEntryForm(context, EntryType.emotion);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEntryForm(BuildContext context, EntryType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return EntryFormWidget(
            type: type,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final Entry entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    // Style determination
    Color backgroundColor;
    Color iconColor;
    IconData iconData;
    Color dateColor;

    switch (entry.type) {
      case EntryType.dream:
        backgroundColor = Colors.deepPurple.shade50;
        iconColor = Colors.deepPurple;
        iconData = Icons.nights_stay;
        dateColor = Colors.deepPurple.shade300;
        break;
      case EntryType.insight:
        backgroundColor = Colors.white;
        iconColor = Colors.amber.shade800;
        iconData = Icons.lightbulb_outline;
        dateColor = Colors.grey;
        break;
      case EntryType.emotion:
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.redAccent;
        iconData = Icons.flash_on;
        dateColor = Colors.red.shade300;
        break;
    }

    final dateStr = DateFormat('dd/MM HH:mm').format(entry.timestamp);

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Card(
        color: backgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title + Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, color: iconColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.title ?? _itemTypeTitle(entry.type),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(color: dateColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                entry.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),

              if (entry.dreamTags != null && entry.dreamTags!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  children: entry.dreamTags!
                      .take(3)
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "#$t",
                            style: TextStyle(fontSize: 10, color: iconColor),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    entry.title ?? _itemTypeTitle(entry.type),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                      'pt_BR',
                    ).format(entry.timestamp),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    entry.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 18, // bodyLarge explicitly requested
                    ),
                  ),

                  // Extra details
                  if (entry.wakeUpMood != null) ...[
                    const SizedBox(height: 20),
                    Divider(),
                    const SizedBox(height: 10),
                    Text(
                      "Humor ao acordar",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(entry.wakeUpMood!, style: TextStyle(fontSize: 16)),
                  ],

                  if (entry.dreamAssociations != null &&
                      entry.dreamAssociations!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      "Associações",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.dreamAssociations!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],

                  if (entry.dreamTags != null &&
                      entry.dreamTags!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: entry.dreamTags!
                          .map(
                            (t) => Chip(
                              label: Text(t),
                              backgroundColor: Colors.grey.shade100,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _itemTypeTitle(EntryType type) {
    switch (type) {
      case EntryType.dream:
        return "Sonho";
      case EntryType.insight:
        return "Insight";
      case EntryType.emotion:
        return "Emoção";
    }
  }
}
