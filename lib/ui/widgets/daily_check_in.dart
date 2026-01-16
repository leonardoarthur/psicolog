import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/providers/journal_provider.dart';

class DailyCheckInWidget extends StatelessWidget {
  const DailyCheckInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JournalProvider>(
      builder: (context, provider, child) {
        final currentMood = provider.todayMood?.mood;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como foi seu dia?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMoodIcon(
                    context,
                    1,
                    Icons.sentiment_very_dissatisfied,
                    Colors.red,
                    currentMood,
                  ),
                  _buildMoodIcon(
                    context,
                    2,
                    Icons.sentiment_dissatisfied,
                    Colors.orange,
                    currentMood,
                  ),
                  _buildMoodIcon(
                    context,
                    3,
                    Icons.sentiment_neutral,
                    Colors.amber,
                    currentMood,
                  ),
                  _buildMoodIcon(
                    context,
                    4,
                    Icons.sentiment_satisfied,
                    Colors.lightGreen,
                    currentMood,
                  ),
                  _buildMoodIcon(
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

  Widget _buildMoodIcon(
    BuildContext context,
    int value,
    IconData icon,
    Color color,
    int? currentMood,
  ) {
    final isSelected = currentMood == value;
    final isAnySelected = currentMood != null;

    // Visual feedback: if selected, full color and scale.
    // If another is selected, slightly faded?
    // Let's just make the selected one pop.

    return GestureDetector(
      onTap: () {
        context.read<JournalProvider>().setDailyMood(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(8),
        transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 32,
          color: isSelected
              ? color
              : (isAnySelected ? Colors.grey.shade300 : Colors.grey.shade500),
        ),
      ),
    );
  }
}
