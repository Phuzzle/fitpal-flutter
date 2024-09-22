import 'exercise.dart';

class UserProgress {
  final String exerciseId;
  int sets;
  int reps;
  double weight;

  UserProgress({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  void updateProgress({int? newSets, int? newReps, double? newWeight}) {
    if (newSets != null) sets = newSets;
    if (newReps != null) reps = newReps;
    if (newWeight != null) weight = newWeight;
  }
}
