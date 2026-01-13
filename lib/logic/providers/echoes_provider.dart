import 'package:flutter/foundation.dart';
import '../../data/services/database_service.dart';
import '../services/text_analysis_service.dart';

class EchoesProvider extends ChangeNotifier {
  final DatabaseService _databaseService;
  final TextAnalysisService _textAnalysisService;

  Map<String, int> _topWords = {};

  EchoesProvider(this._databaseService, this._textAnalysisService) {
    _init();
  }

  Map<String, int> get topWords => _topWords;

  void _init() {
    _databaseService.watchEntries().listen((entries) {
      _topWords = _textAnalysisService.analyze(entries);
      // We take top 20
      if (_topWords.length > 20) {
        final sortedKeys = _topWords.keys.toList();
        final limitedMap = <String, int>{};
        for (int i = 0; i < 20; i++) {
          final key = sortedKeys[i];
          limitedMap[key] = _topWords[key]!;
        }
        _topWords = limitedMap;
      }
      notifyListeners();
    });
  }
}
