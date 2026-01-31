import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../logic/providers/journal_provider.dart';
import '../../data/models/entry.dart';
import '../widgets/entry_form.dart';

class DreamsScreen extends StatelessWidget {
  const DreamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine greeting
    final hour = DateTime.now().hour;
    String greeting = 'Bom dia';
    if (hour >= 12 && hour < 18) greeting = 'Boa tarde';
    if (hour >= 18) greeting = 'Boa noite';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$greeting, Leonardo',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pr pronto para registrar seus sonhos?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    label: const Text('GRAVAR SONHO AGORA'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Consumer<JournalProvider>(
                builder: (context, provider, child) {
                  // Filter only dreams
                  final dreams = provider.entries
                      .where((e) => e.type == EntryType.dream)
                      .toList();

                  if (dreams.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_off,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          const SizedBox(height: 16),
                          const Text('Nenhum sonho registrado ainda.'),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: dreams.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final dream = dreams[index];
                      return _DreamTimelineItem(dream: dream);
                    },
                  );
                },
              ),
            ),
          ],
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
                    DateFormat('dd MMM, HH:mm').format(dream.timestamp),
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
              Text(
                dream.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
