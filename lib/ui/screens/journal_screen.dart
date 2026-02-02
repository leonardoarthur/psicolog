import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'catharsis_screen.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import 'mood_calendar_screen.dart';
import '../widgets/entry_form.dart';
import 'settings_screen.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            // DailyCheckInWidget removed from here
            Expanded(
              child: Consumer<JournalProvider>(
                builder: (context, provider, child) {
                  final entries = provider.entries
                      .where((e) => e.type != EntryType.therapy)
                      .toList();
                  if (entries.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
        '${dayName[0].toUpperCase()}${dayName.substring(1)}, $dayNum ${month[0].toUpperCase()}${month.substring(1)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateStr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
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
                icon: Icon(
                  Icons.calendar_month,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CatharsisScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.local_fire_department,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        databaseService: context
                            .read<JournalProvider>()
                            .databaseService,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
            ],
          ),
        );
      },
    );
  }

  void _showEntryForm(BuildContext context, EntryType type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryFormWidget(
          type: type,
          // scrollController passed as dummy or removed if we clean up EntryFormWidget constructor
          scrollController: ScrollController(),
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final Entry entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    // Style determination based on theme
    // final colorScheme = Theme.of(context).colorScheme; // Not used currently
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color accentColor;
    IconData iconData;

    switch (entry.type) {
      case EntryType.dream:
        accentColor = isDark ? const Color(0xFFD1C4E9) : Colors.deepPurple;
        iconData = Icons.nights_stay;
        break;
      case EntryType.insight:
        accentColor = isDark ? const Color(0xFFFFCC80) : Colors.amber.shade800;
        iconData = Icons.lightbulb_outline;
        break;
      case EntryType.emotion:
        accentColor = isDark ? const Color(0xFFEF9A9A) : Colors.redAccent;
        iconData = Icons.flash_on;
        break;
      case EntryType.therapy:
        accentColor = isDark ? Colors.tealAccent : Colors.teal;
        iconData = Icons.self_improvement;
        break;
    }

    final dateStr = DateFormat('dd/MM HH:mm').format(entry.timestamp);

    return GestureDetector(
      onTap: () => _showDetails(context),
      onLongPress: () => _showOptions(context),
      child: Card(
        // Theme handles color, we just override shape for border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: accentColor.withValues(alpha: 0.5), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title + Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, color: accentColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        if (entry.isPinned) ...[
                          Icon(Icons.push_pin, size: 14, color: accentColor),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            entry.title ?? _itemTypeTitle(entry.type),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
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
                  color: Theme.of(context).colorScheme.onSurface,
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
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#$t',
                            style: TextStyle(fontSize: 10, color: accentColor),
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
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Humor ao acordar',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(entry.wakeUpMood!, style: const TextStyle(fontSize: 16)),
                  ],

                  if (entry.dreamAssociations != null &&
                      entry.dreamAssociations!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Associações',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.dreamAssociations!,
                      style: const TextStyle(fontSize: 16),
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

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  entry.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                ),
                title: Text(entry.isPinned ? 'Desafixar' : 'Fixar'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<JournalProvider>().togglePin(entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEntryFormWithEntry(context, entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEntryFormWithEntry(BuildContext context, Entry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryFormWidget(
          type: entry.type,
          scrollController: ScrollController(),
          entryToEdit: entry,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir entrada?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              context.read<JournalProvider>().deleteEntry(entry.id);
            },
            child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _itemTypeTitle(EntryType type) {
    switch (type) {
      case EntryType.dream:
        return 'Sonho';
      case EntryType.insight:
        return 'Insight';
      case EntryType.emotion:
        return 'Emoção';
      case EntryType.therapy:
        return 'Terapia';
    }
  }
}
