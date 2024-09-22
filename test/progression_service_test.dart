import 'package:flutter_test/flutter_test.dart';
import '../lib/services/progression_service.dart';
import '../lib/models/exercise.dart';

void main() {
  group('ProgressionService Tests', () {
    final progressionService = ProgressionService();

    test('Initial progression for weighted exercise', () {
      final exercise = Exercise(id: 'ex1', name: 'Bench Press', muscleGroup: 'Pec Dominant', isBodyWeight: false);
      final progress = progressionService.getProgress(exercise);

      expect(progress.sets, 3);
      expect(progress.reps, 8);
      expect(progress.weight, 20.0);
    });

    test('Progression after completing 5x12 weighted exercise', () {
      final exercise = Exercise(id: 'ex1', name: 'Bench Press', muscleGroup: 'Pec Dominant', isBodyWeight: false);
      // Simulate completing up to 5x12
      progressionService.updateProgress(exercise); // 4x8
      progressionService.updateProgress(exercise); // 5x8
      progressionService.updateProgress(exercise); // 3x10
      progressionService.updateProgress(exercise); // 4x10
      progressionService.updateProgress(exercise); // 5x10
      progressionService.updateProgress(exercise); // 3x12
      progressionService.updateProgress(exercise); // 4x12
      progressionService.updateProgress(exercise); // 5x12 -> should increase weight

      final updatedProgress = progressionService.getProgress(exercise);

      expect(updatedProgress.sets, 3);
      expect(updatedProgress.reps, 8);
      expect(updatedProgress.weight, 22.0); // 20 * 1.10 = 22
    });

    test('Progression for bodyweight exercise', () {
      final exercise = Exercise(id: 'ex2', name: 'Push-Up', muscleGroup: 'Pec Dominant', isBodyWeight: true);
      // Simulate completing up to 5x12
      for (int i = 0; i < 9; i++) {
        progressionService.updateProgress(exercise);
      }

      final updatedProgress = progressionService.getProgress(exercise);

      expect(updatedProgress.sets, 5);
      expect(updatedProgress.reps, 12);
      expect(updatedProgress.weight, 0.0); // No weight change
    });
  });
}
