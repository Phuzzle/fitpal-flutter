import '../models/user_progress.dart';
import '../models/exercise.dart';
import 'dart:math';

class ProgressionService {
  static final ProgressionService _instance = ProgressionService._internal();

  factory ProgressionService() {
    return _instance;
  }

  ProgressionService._internal();

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

  Map<String, int> _currentStepMap = {};

  Map<String, UserProgress> _userProgressMap = {};

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
      _currentStepMap[exercise.id] = 0;
      return _userProgressMap[exercise.id]!;
    }
  }

  UserProgress updateProgress(Exercise exercise) {
    UserProgress progress = getProgress(exercise);
    int currentStep = _currentStepMap[exercise.id] ?? 0;
    int patternLength = _progressionPattern.length;

    if (progress.sets == 5 && progress.reps == 12) {
      if (!exercise.isBodyWeight) {
        // Increase weight by 10%, rounded to nearest 2.5kg
        double newWeight = (progress.weight * 1.10).clamp(0.0, double.infinity);
        newWeight = (newWeight / 2.5).round() * 2.5;
        progress.updateProgress(weight: newWeight);
        // Reset to initial progression
        currentStep = 0;
      } else {
        // For bodyweight, continue progression without weight change
        currentStep = (currentStep + 1) % patternLength;
      }
    } else {
      currentStep = (currentStep + 1) % patternLength;
    }

    // Update sets and reps based on progression pattern
    progress.updateProgress(
      sets: _progressionPattern[currentStep]['sets']!,
      reps: _progressionPattern[currentStep]['reps']!
    );

    _currentStepMap[exercise.id] = currentStep;
    _userProgressMap[exercise.id] = progress;

    return progress;
  }

  Map<String, int> getNextProgression(Exercise exercise) {
    int currentStep = _currentStepMap[exercise.id] ?? 0;
    int nextStep = (currentStep + 1) % _progressionPattern.length;
    return _progressionPattern[nextStep];
  }
}
