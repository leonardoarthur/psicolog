import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';

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
                'Como foi seu dia?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMoodEmoji(context, 1, '😢', currentMood),
                  _buildMoodEmoji(context, 2, '😕', currentMood),
                  _buildMoodEmoji(context, 3, '😐', currentMood),
                  _buildMoodEmoji(context, 4, '🙂', currentMood),
                  _buildMoodEmoji(context, 5, '😄', currentMood),
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
    String emoji,
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
          opacity: isSelected ? 1.0 : (isAnySelected ? 0.3 : 0.7),
          child: Text(emoji, style: const TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}
