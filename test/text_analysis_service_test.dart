import 'package:flutter_test/flutter_test.dart';
import 'package:psicolog/data/models/entry.dart';
import 'package:psicolog/logic/services/text_analysis_service.dart';

void main() {
  group('TextAnalysisService', () {
    test('should count words correctly and ignore stopwords', () {
      final service = TextAnalysisService();
      final entries = [
        Entry()..content = 'O rato roeu a roupa do rei de Roma',
        Entry()..content = 'O rei ficou bravo',
      ];

      final result = service.analyze(entries);

      expect(result['rei'], 2);
      expect(result['rato'], 1);
      expect(result['roeu'], 1);
      expect(result['roupa'], 1); // 'roupa' is 1
      expect(result['roma'], 1);
      expect(result['bravo'], 1);
      expect(result['ficou'], 1);

      // Stopwords check
      expect(result.containsKey('o'), false);
      expect(result.containsKey('a'), false);
      expect(result.containsKey('do'), false);
      expect(result.containsKey('de'), false);
    });

    test('should handle punctuation and case', () {
      final service = TextAnalysisService();
      final entries = [Entry()..content = 'Olá! Tudo bem? Tudo bem.'];

      final result = service.analyze(entries);

      expect(result['tudo'], 2);
      expect(result['bem'], 2);
      expect(result['olá'], 1);
    });
  });
}
