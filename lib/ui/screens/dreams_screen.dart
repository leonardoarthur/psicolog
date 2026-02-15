import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import '../../data/models/app_settings.dart';
import '../widgets/entry_form.dart';
import '../widgets/expandable_dream_text.dart';
import 'package:psicolog/l10n/app_localizations.dart';

import 'package:flutter_animate/flutter_animate.dart';

class DreamsScreen extends StatelessWidget {
  const DreamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Determine greeting
    final hour = DateTime.now().hour;
    String greeting = l10n.goodMorning;
    if (hour >= 12 && hour < 18) greeting = l10n.goodAfternoon;
    if (hour >= 18) greeting = l10n.goodEvening;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<JournalProvider>(
          builder: (context, provider, child) {
            // Filter only dreams
            final dreams = provider.entries
                .where((e) => e.type == EntryType.dream)
                .toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  floating: true,
                  pinned: false,
                  snap: true,
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FutureBuilder<AppSettings>(
                            future: provider.databaseService.getAppSettings(),
                            builder: (context, snapshot) {
                              final name =
                                  snapshot.data?.userName ?? l10n.visitor;
                              return Text(
                                '$greeting, $name',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.dreamPrompt,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 8.0,
                    ),
                    child:
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntryFormWidget(
                                  type: EntryType.dream,
                                  scrollController: ScrollController(),
                                ),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                          icon: const Icon(Icons.nights_stay),
                          label: Text(l10n.recordDreamNow),
                        ).animate().scale(
                          duration: 300.ms,
                          curve: Curves.easeOutBack,
                        ),
                  ),
                ),
                if (dreams.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                                Icons.cloud_off,
                                size: 64,
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                              )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                                duration: 2000.ms,
                              ),
                          const SizedBox(height: 16),
                          Text(l10n.noDreamsYet),
                        ],
                      ).animate().fadeIn(duration: 600.ms),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final dream = dreams[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _DreamTimelineItem(dream: dream)
                              .animate()
                              .fadeIn(duration: 500.ms, delay: (50 * index).ms)
                              .slideX(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                        );
                      }, childCount: dreams.length),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DreamTimelineItem extends StatelessWidget {
  final Entry dream;
  const _DreamTimelineItem({required this.dream});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 60, // Adjustable
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat(
                      'dd MMM, HH:mm',
                      Localizations.localeOf(context).toString(),
                    ).format(dream.timestamp),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  if (dream.wakeUpMood != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dream.wakeUpMood!,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              // Tags
              if (dream.dreamTags != null && dream.dreamTags!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Wrap(
                    spacing: 4,
                    children: dream.dreamTags!
                        .map(
                          (tag) => Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.secondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ExpandableDreamText(text: dream.content),
            ],
          ),
        ),
      ],
    );
  }
}
