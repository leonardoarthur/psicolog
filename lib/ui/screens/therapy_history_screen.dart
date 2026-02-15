import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import '../widgets/entry_form.dart';
import 'package:psicolog/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TherapyHistoryScreen extends StatelessWidget {
  const TherapyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<JournalProvider>(
          builder: (context, provider, child) {
            final entries = provider.entries
                .where((e) => e.type == EntryType.therapy)
                .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  pinned: false,
                  snap: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: Text(
                      'Minha Terapia',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                ),
                if (entries.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                                Icons.self_improvement,
                                size: 64,
                                color: Colors.teal,
                              )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 2000.ms,
                              ),
                          const SizedBox(height: 16),
                          Text(AppLocalizations.of(context)!.noTherapyRecorded),
                        ],
                      ).animate().fadeIn(duration: 600.ms),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final entry = entries[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TherapyCard(entry: entry)
                              .animate()
                              .fadeIn(duration: 500.ms, delay: (50 * index).ms)
                              .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                        );
                      }, childCount: entries.length),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryFormWidget(
                type: EntryType.therapy,
                scrollController: ScrollController(),
              ),
            ),
          );
        },
        label: Text(AppLocalizations.of(context)!.newSession),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _TherapyCard extends StatelessWidget {
  final Entry entry;
  const _TherapyCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptions(context),
      onTap: () => _showOptions(
        context,
      ), // Also on tap for easier access? Or maybe just LongPress? User said "Assim como no 'Diário' o usuario pode editar os card da 'Terapia'" which implies same interaction. Diary has Tap->Details, LongPress->Options. Therapy card is already full content, so maybe Tap->Edit or Options. Let's do Options on Tap for simplicity as there is no detail view needed.
      child: Card(
        elevation: 4,
        shadowColor: Colors.teal.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          'dd MMM yyyy, HH:mm',
                          'pt_BR',
                        ).format(entry.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (entry.isPinned)
                    const Icon(Icons.push_pin, size: 16, color: Colors.teal),
                ],
              ),
              const SizedBox(height: 12),

              // Content (Resumo)
              Text(
                entry.content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),

              const SizedBox(height: 20),

              // Reflection Highlight (O que mais te fez refletir)
              if (entry.therapyKeyLesson != null &&
                  entry.therapyKeyLesson!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal.withValues(alpha: 0.15),
                        Colors.teal.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.teal.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'REFLEXÃO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        entry.therapyKeyLesson!,
                        style: TextStyle(
                          color: Colors.teal[900],
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  entry.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                  color: Colors.teal,
                ),
                title: Text(entry.isPinned ? l10n.unpin : l10n.pin),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<JournalProvider>().togglePin(entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text(l10n.edit),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEntryFormWithEntry(context, entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  l10n.delete,
                  style: const TextStyle(color: Colors.red),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteSessionTitle),
        content: Text(l10n.deleteEntryContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              context.read<JournalProvider>().deleteEntry(entry.id);
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
