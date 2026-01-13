import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/echoes_provider.dart';

class EchoesScreen extends StatelessWidget {
  const EchoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ecos')),
      body: Consumer<EchoesProvider>(
        builder: (context, provider, child) {
          final topWords = provider.topWords;

          if (topWords.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Escreva mais no seu diário para ver os significantes aparecerem aqui.',
                  textAlign: TextAlign.center,
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
              children: topWords.entries.map((entry) {
                final word = entry.key;
                final count = entry.value;

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
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
