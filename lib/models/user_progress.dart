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
}
