import 'package:flutter/foundation.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gameverse/domain/models/play_time_model/play_time_model.dart';
import 'package:gameverse/data/repositories/playtime_repository.dart';
import 'package:intl/intl.dart';

enum AnalysisTimeFrame { daily, weekly, monthly }
enum AnalysisState { initial, loading, success, error }

class PlaytimeAnalysisViewModel extends ChangeNotifier {
  final PlaytimeRepository _playtimeRepository;
  final AuthRepository _authRepository;
  static const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  PlaytimeAnalysisViewModel({
    required PlaytimeRepository playtimeRepository,
    required AuthRepository authRepository,
  })  : _playtimeRepository = playtimeRepository,
        _authRepository = authRepository {
    // Initialize with default timeframe
    setTimeFrame(AnalysisTimeFrame.weekly);
  }

  AnalysisState _state = AnalysisState.initial;
  AnalysisTimeFrame _timeFrame = AnalysisTimeFrame.weekly;
  String _errorMessage = '';
  String _aiAnalysis = '';
  String _aiAdvice = '';
  List<PlayTimeModel> _playtimeSessions = [];
  Map<String, Duration> _playtimeByDay = {};

  AnalysisState get state => _state;
  AnalysisTimeFrame get timeFrame => _timeFrame;
  String get errorMessage => _errorMessage;
  String get aiAnalysis => _aiAnalysis;
  String get aiAdvice => _aiAdvice;
  List<PlayTimeModel> get playtimeSessions => _playtimeSessions;
  Map<String, Duration> get playtimeByDay => _playtimeByDay;
  
  // Change the time frame and fetch appropriate data
  Future<void> setTimeFrame(AnalysisTimeFrame newTimeFrame) async {
    _timeFrame = newTimeFrame;
    notifyListeners();
    await fetchPlaytimeData();
  }
  
  Future<void> fetchPlaytimeData() async {
    try {
      _state = AnalysisState.loading;
      notifyListeners();
      
      final DateTime now = DateTime.now();
      DateTime startDate;
      
      switch (_timeFrame) {
        case AnalysisTimeFrame.daily:
          startDate = now.subtract(const Duration(days: 1));
          break;
        case AnalysisTimeFrame.weekly:
          startDate = now.subtract(const Duration(days: 7));
          break;
        case AnalysisTimeFrame.monthly:
          startDate = now.subtract(const Duration(days: 30));
          break;
      }
      
      _playtimeSessions = await _playtimeRepository.getPlaytimeSessions(
        token: _authRepository.accessToken,
        startDate: startDate,
        endDate: now,
      );
      
      // Process data for visualization
      _processPlaytimeData();
      
      _state = AnalysisState.success;
    } catch (e) {
      _state = AnalysisState.error;
      _errorMessage = 'Failed to load playtime data: $e';
    } finally {
      notifyListeners();
    }
  }
  
  // Process playtime data into format suitable for charts
  void _processPlaytimeData() {
    _playtimeByDay = {};
    
    for (var session in _playtimeSessions) {
      final day = DateFormat('yyyy-MM-dd').format(session.begin);
      
      final Duration sessionDuration;
      if (session.end != null) {
        sessionDuration = session.end!.difference(session.begin);
      } else {
        sessionDuration = DateTime.now().difference(session.begin);
      }
      
      if (_playtimeByDay.containsKey(day)) {
        _playtimeByDay[day] = _playtimeByDay[day]! + sessionDuration;
      } else {
        _playtimeByDay[day] = sessionDuration;
      }
    }
  }
  
  Future<void> analyzePlaytimeWithAI() async {
    try {
      _state = AnalysisState.loading;
      _aiAnalysis = '';
      _aiAdvice = '';
      notifyListeners();

      final StringBuilder dataForAI = StringBuilder();
      
      dataForAI.writeLine('Playtime data for analysis:');
      
      final double totalHours = _playtimeByDay.values
          .fold(Duration.zero, (prev, curr) => prev + curr)
          .inMinutes / 60.0;
      
      dataForAI.writeLine('Total playtime: ${totalHours.toStringAsFixed(4)} hours');
      
      final double avgDailyHours = totalHours / _playtimeByDay.length;
      dataForAI.writeLine('Average daily playtime: ${avgDailyHours.toStringAsFixed(4)} hours');
      
      dataForAI.writeLine('\nDaily playtime breakdown:');
      
      List<MapEntry<String, Duration>> sortedEntries = _playtimeByDay.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      
      for (var entry in sortedEntries) {
        final hours = entry.value.inMinutes / 60.0;
        dataForAI.writeLine('${entry.key}: ${hours.toStringAsFixed(4)} hours');
      }
      
      dataForAI.writeLine('\nSession count: ${_playtimeSessions.length}');
      
      // Add request for analysis and advice
      dataForAI.writeLine('''
\nBased on this playtime data, please provide:
1. A brief analysis of the user's gaming habits
2. Specific advice for healthier gaming habits
3. Potential concerns if you see any unhealthy patterns
4. Positive aspects of their current habits

Please format your response in two sections: "Analysis" and "Recommendations".
''');
      
      // Call Gemini API
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: _geminiApiKey,
      );
      
      final content = [Content.text(dataForAI.toString())];
      final response = await model.generateContent(content);
      
      final responseText = response.text ?? 'No analysis available.';
      
      // Split into analysis and advice sections
      if (responseText.contains('Analysis') && responseText.contains('Recommendations')) {
        final analysisSection = responseText.split('Recommendations')[0].replaceAll('Analysis', '').trim();
        final adviceSection = responseText.split('Recommendations')[1].trim();
        
        _aiAnalysis = analysisSection;
        _aiAdvice = adviceSection;
      } else {
        _aiAnalysis = responseText;
        _aiAdvice = '';
      }
      
      _state = AnalysisState.success;
    } catch (e) {
      _state = AnalysisState.error;
      _errorMessage = 'AI analysis failed: $e';
    } finally {
      notifyListeners();
    }
  }
}

class StringBuilder {
  final StringBuffer _buffer = StringBuffer();
  
  void writeLine(String line) {
    _buffer.writeln(line);
  }
  
  @override
  String toString() {
    return _buffer.toString();
  }
}