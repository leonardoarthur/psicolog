import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/echoes_provider.dart';
import 'package:psicolog/l10n/app_localizations.dart';

import 'package:flutter_animate/flutter_animate.dart';

class EchoesScreen extends StatelessWidget {
  const EchoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navEchoes)),
      body: Consumer<EchoesProvider>(
        builder: (context, provider, child) {
          final topWords = provider.topWords;

          if (topWords.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          Icons.graphic_eq,
                          size: 64,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.1, 1.1),
                          duration: 2000.ms,
                        )
                        .fadeIn(duration: 600.ms),
                    const SizedBox(height: 16),
                    Text(
                      l10n.echoesEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                  ],
                ),
              ),
            );
          }

          final maxFrequency = topWords.values.isNotEmpty
              ? topWords.values.reduce(
                  (curr, next) => curr > next ? curr : next,
                )
              : 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: topWords.entries.toList().asMap().entries.map((entry) {
                final index = entry.key;
                final mapEntry = entry.value;
                final word = mapEntry.key;
                final count = mapEntry.value;

                // Opacity based on frequency
                final intensity = (count / maxFrequency).clamp(0.4, 1.0);

                return Chip(
                      label: Text(
                        word.toUpperCase(),
                        style: TextStyle(
                          fontWeight: count == maxFrequency
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      avatar: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: intensity),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      side: BorderSide.none,
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (30 * index).ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      curve: Curves.easeOutBack,
                    );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
