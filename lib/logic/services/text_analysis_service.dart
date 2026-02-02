import '../../data/models/entry.dart';

class TextAnalysisService {
  static const Set<String> _stopwords = {
    'a',
    'o',
    'e',
    'é',
    'de',
    'do',
    'da',
    'em',
    'um',
    'uma',
    'para',
    'com',
    'não',
    'que',
    'os',
    'as',
    'nos',
    'nas',
    'por',
    'mas',
    'se',
    'foi',
    'eu',
    'me',
    'meu',
    'minha',
    'ele',
    'ela',
    'isso',
    'aquilo',
    'estava',
    'estou',
    'tinha',
    'tenho',
    'muito',
    'mais',
    'como',
    'quando',
    'onde',
    'quem',
    'tão',
    'são',
    'era',
    'ser',
    'tem',
    'dos',
    'das',
    'ou',
    'então',
    'agora',
    'depois',
    'tudo',
    'nada',
    'fim',
    'dia',
    'hoje',
    'ontem',
    'aqui',
    'ali',
    // Adding some common extra ones that were there before if not covered
    'no',
    'na',
    'voce',
    'você',
    'ta',
    'tá',
    'ao',
    'esta',
    'este',
    'pelo',
    'pela',
    'ter',
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
