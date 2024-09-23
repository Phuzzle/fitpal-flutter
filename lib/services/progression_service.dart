import '../models/user_progress.dart';
import '../models/exercise.dart';
import 'dart:math';

class ProgressionService {
  // Define the progression pattern
  final List<Map<String, int>> _progressionPattern = [
    {'sets': 3, 'reps': 8},
    {'sets': 4, 'reps': 8},
    {'sets': 5, 'reps': 8},
    {'sets': 3, 'reps': 10},
    {'sets': 4, 'reps': 10},
    {'sets': 5, 'reps': 10},
    {'sets': 3, 'reps': 12},
    {'sets': 4, 'reps': 12},
    {'sets': 5, 'reps': 12},
  ];

  int _currentStep = 0;

  Map<String, UserProgress> _userProgressMap = {};

  ProgressionService();

  UserProgress getProgress(Exercise exercise) {
    if (_userProgressMap.containsKey(exercise.id)) {
      return _userProgressMap[exercise.id]!;
    } else {
      // Initialize progress
      _userProgressMap[exercise.id] = UserProgress(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        scheduleId: '', // You might want to pass this as a parameter
        date: DateTime.now().toIso8601String(),
        exerciseId: exercise.id,
        sets: 3,
        reps: 8,
        weight: exercise.isBodyWeight ? 0.0 : 20.0, // Initial weight can be set by user
      );
      return _userProgressMap[exercise.id]!;
    }
  }

  void updateProgress(Exercise exercise) {
    UserProgress progress = getProgress(exercise);
    int patternLength = _progressionPattern.length;

    if (progress.sets == 5 && progress.reps == 12) {
      if (!exercise.isBodyWeight) {
        // Increase weight by 10%, rounded to nearest 2.5kg
        double newWeight = (progress.weight * 1.10).clamp(0.0, double.infinity);
        newWeight = (newWeight / 2.5).round() * 2.5;
        progress.updateProgress(weight: newWeight);
        // Reset to initial progression
        _currentStep = 0;
      } else {
        // For bodyweight, continue progression without weight change
        _currentStep = (_currentStep + 1) % patternLength;
      }
    } else {
      _currentStep = (_currentStep + 1) % patternLength;
    }

    // Update sets and reps based on progression pattern
    if (_currentStep < _progressionPattern.length) {
      progress.updateProgress(
        sets: _progressionPattern[_currentStep]['sets']!,
        reps: _progressionPattern[_currentStep]['reps']!
      );
    }
  }
}
