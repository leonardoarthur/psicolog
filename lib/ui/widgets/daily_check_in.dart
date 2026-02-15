import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';
import 'package:psicolog/l10n/app_localizations.dart';

class DailyMoodSelector extends StatelessWidget {
  const DailyMoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final currentMood = provider.todayMood?.mood;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.howWasYourDay,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMoodEmoji(
                    context,
                    1,
                    Icons.sentiment_very_dissatisfied,
                    Colors.redAccent,
                    currentMood,
                  ),
                  _buildMoodEmoji(
                    context,
                    2,
                    Icons.sentiment_dissatisfied,
                    Colors.orangeAccent,
                    currentMood,
                  ),
                  _buildMoodEmoji(
                    context,
                    3,
                    Icons.sentiment_neutral,
                    Colors.amber,
                    currentMood,
                  ),
                  _buildMoodEmoji(
                    context,
                    4,
                    Icons.sentiment_satisfied,
                    Colors.lightGreen,
                    currentMood,
                  ),
                  _buildMoodEmoji(
                    context,
                    5,
                    Icons.sentiment_very_satisfied,
                    Colors.green,
                    currentMood,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodEmoji(
    BuildContext context,
    int value,
    IconData icon,
    Color color,
    int? currentMood,
  ) {
    final isSelected = currentMood == value;
    final isAnySelected = currentMood != null;

    return GestureDetector(
      onTap: () {
        context.read<JournalProvider>().setDailyMood(value);
      },
      child: AnimatedScale(
        scale: isSelected ? 1.4 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutBack,
        child: Opacity(
          opacity: isSelected ? 1.0 : (isAnySelected ? 0.3 : 1.0),
          child: Icon(
            icon,
            size: 32,
            color: isSelected || !isAnySelected ? color : Colors.grey,
          ),
        ),
      ),
    );
  }
}
