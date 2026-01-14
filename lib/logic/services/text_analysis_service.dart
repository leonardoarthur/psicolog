import '../../data/models/entry.dart';

class TextAnalysisService {
  static const Set<String> _stopwords = {
    'de',
    'a',
    'o',
    'que',
    'e',
    'do',
    'da',
    'em',
    'um',
    'uma',
    'para',
    'com',
    'não',
    'os',
    'as',
    'no',
    'na',
    'nos',
    'nas',
    'se',
    'mas',
    'foi',
    'ele',
    'ela',
    'eu',
    'você',
    'por',
    'como',
    'mais',
    'tá',
    'tem',
    'ao',
    'meu',
    'minha',
    'está',
    'estava',
    'ser',
    'isso',
    'aquilo',
    'este',
    'esta',
    'são',
    'era',
    'pelo',
    'pela',
    'dos',
    'das',
    'ou',
    'quando',
    'muito',
    'então',
    'tinha',
    'ter',
    'me',
    'seus',
    'suas',
    'teu',
    'tua',
    'num',
    'numa',
  };

  Map<String, int> analyze(List<Entry> entries) {
    final Map<String, int> wordCount = {};

    for (final entry in entries) {
      final text = entry.content.toLowerCase();
      // Remove punctuation and newlines
      final cleanedText = text
          .replaceAll(RegExp(r'[^\w\s\u00C0-\u00FF]'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ');

      final words = cleanedText.split(' ');

      for (var word in words) {
        word = word.trim();
        if (word.isNotEmpty && !_stopwords.contains(word)) {
          wordCount[word] = (wordCount[word] ?? 0) + 1;
        }
      }
    }

    // Sort by frequency (descending)
    final sortedEntries = wordCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }
}
